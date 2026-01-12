//
//  EditorView.swift
//  Script-Ware
//
//  Created by Nguyen Nam on 11/1/26.
//

import SwiftUI
import WebKit

struct EditorView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var tabManager = TabManager()
    @State private var showUtilities = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab bar
            TabBarView(tabManager: tabManager)
                .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            
            // Monaco Editor
            MonacoEditorView(tabManager: tabManager)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color(white: 0.42), width: 1)
            
            // Toolbar
            ToolbarView(showUtilities: $showUtilities, tabManager: tabManager)
        }
        .background(Color(red: 0.17, green: 0.17, blue: 0.17))
        .frame(width: 625, height: 375)
        .sheet(isPresented: $showUtilities) {
            UtilitiesView(isPresented: $showUtilities, tabManager: tabManager)
        }
    }
}

// MARK: - Tab Manager
class TabManager: ObservableObject {
    @Published var tabs: [ScriptTab] = [ScriptTab(id: "ScriptWare", title: "Script-Ware M", content: "")]
    @Published var selectedTabId: String = "ScriptWare"
    
    var currentContent: String {
        get { tabs.first { $0.id == selectedTabId }?.content ?? "" }
        set {
            if let index = tabs.firstIndex(where: { $0.id == selectedTabId }) {
                tabs[index].content = newValue
            }
        }
    }
    
    func addTab() {
        let id = UUID().uuidString.prefix(10).lowercased()
        let tab = ScriptTab(id: String(id), title: String(id), content: "")
        tabs.append(tab)
        selectedTabId = tab.id
    }
    
    func closeTab(_ id: String) {
        guard id != "ScriptWare" else { return }
        tabs.removeAll { $0.id == id }
        if selectedTabId == id {
            selectedTabId = tabs.first?.id ?? "ScriptWare"
        }
    }
}

struct ScriptTab: Identifiable {
    let id: String
    var title: String
    var content: String
}

// MARK: - Tab Bar
struct TabBarView: View {
    @ObservedObject var tabManager: TabManager
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(tabManager.tabs) { tab in
                TabItemView(tab: tab, isSelected: tab.id == tabManager.selectedTabId, tabManager: tabManager)
            }
            
            if tabManager.tabs.count < 5 {
                Button(action: { tabManager.addTab() }) {
                    Text("+")
                        .foregroundColor(Color(white: 0.89))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(white: 0.29))
                        .cornerRadius(3)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            Image("AppIconImage")
                .resizable()
                .interpolation(.high)
                .frame(width: 20, height: 20)
                .padding(.trailing, 4)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

struct TabItemView: View {
    let tab: ScriptTab
    let isSelected: Bool
    @ObservedObject var tabManager: TabManager
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tab.title)
                .font(.system(size: 12))
                .foregroundColor(Color(white: 0.89))
            
            if tab.id != "ScriptWare" {
                Button(action: { tabManager.closeTab(tab.id) }) {
                    Text("×")
                        .foregroundColor(Color(white: 0.73))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(isSelected ? Color(white: 0.42) : Color(white: 0.29))
        .cornerRadius(3)
        .onTapGesture {
            tabManager.selectedTabId = tab.id
        }
    }
}

// MARK: - Monaco Editor WebView
struct MonacoEditorView: NSViewRepresentable {
    @ObservedObject var tabManager: TabManager
    
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                * { margin: 0; padding: 0; }
                html, body { width: 100%; height: 100%; overflow: hidden; background: #1e1e1e; }
                #container { width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            <div id="container"></div>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.44.0/min/vs/loader.min.js"></script>
            <script>
                require.config({ paths: { vs: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.44.0/min/vs' } });
                require(['vs/editor/editor.main'], function () {
                    window.editor = monaco.editor.create(document.getElementById('container'), {
                        value: '',
                        language: 'lua',
                        theme: 'vs-dark',
                        minimap: { enabled: false },
                        automaticLayout: true,
                        fontSize: 14
                    });
                });
                
                function getEditorContent() {
                    return window.editor ? window.editor.getValue() : '';
                }
                
                function setEditorContent(content) {
                    if (window.editor) window.editor.setValue(content);
                }
                
                function clearEditor() {
                    if (window.editor) window.editor.setValue('');
                }
            </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: MonacoEditorView
        
        init(_ parent: MonacoEditorView) {
            self.parent = parent
        }
    }
}

// MARK: - Toolbar
struct ToolbarView: View {
    @Binding var showUtilities: Bool
    @ObservedObject var tabManager: TabManager
    
    var body: some View {
        HStack {
            // Left buttons - using SF Symbols
            HStack(spacing: 12) {
                Button(action: executeScript) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0, green: 0x74/255, blue: 0x16/255)) // #007416
                }
                .buttonStyle(.plain)
                
                Button(action: pasteFromClipboard) {
                    Image(systemName: "doc.on.clipboard.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0xFF/255, green: 0xE1/255, blue: 0xBD/255)) // #ffe1bd
                }
                .buttonStyle(.plain)
                
                Button(action: clearEditor) {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0xFF/255, green: 0xBD/255, blue: 0xBD/255)) // #ffbdbd
                }
                .buttonStyle(.plain)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Right buttons
            HStack(spacing: 3) {
                Button("Dex by Moon") {
                    // Execute Dex
                }
                .buttonStyle(ToolbarButtonStyle())
                
                Button("Utilities & Library") {
                    showUtilities = true
                }
                .buttonStyle(ToolbarButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(red: 0.17, green: 0.17, blue: 0.17))
    }
    
    func executeScript() {
        print("Execute script")
    }
    
    func pasteFromClipboard() {
        if let content = NSPasteboard.general.string(forType: .string) {
            print("Paste: \(content)")
        }
    }
    
    func clearEditor() {
        print("Clear editor")
    }
}

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 11))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(configuration.isPressed ? Color(white: 0.4) : Color(white: 0.17))
    }
}

#Preview {
    EditorView()
        .environmentObject(AppState())
}
