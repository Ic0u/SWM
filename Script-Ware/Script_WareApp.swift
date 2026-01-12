//
//  Script_WareApp.swift
//  Script-Ware
//
//  Created by Nguyen Nam on 11/1/26.
//

import SwiftUI

@main
struct Script_WareApp: App {
    @StateObject private var appState = AppState()
    
    // #1A1A1A
    private let bgColor = Color(red: 0x1A/255, green: 0x1A/255, blue: 0x1A/255)
    
    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isLoggedIn {
                    EditorView()
                        .environmentObject(appState)
                } else {
                    LoginView()
                        .environmentObject(appState)
                }
            }
            .background(bgColor)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

class AppState: ObservableObject {
    @Published var isLoggedIn = false
    @Published var username = ""
}
