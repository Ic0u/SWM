//
//  UtilitiesView.swift
//  Script-Ware
//
//  Created by Nguyen Nam on 11/1/26.
//

import SwiftUI

struct UtilitiesView: View {
    @Binding var isPresented: Bool
    @ObservedObject var tabManager: TabManager
    @State private var decompileScripts = false
    
    var body: some View {
        ZStack {
            Color(white: 0.97)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Text("×")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(white: 0.67))
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 10)
                }
                
                HStack(alignment: .top, spacing: 10) {
                    // Save Place card
                    VStack {
                        Image("saveinstance")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                        Text("Save Place")
                            .font(.system(size: 14, weight: .bold))
                        
                        Text("The most accurate place-saver ever. Written by Moon. Save Meshes and UnionOperations featuring collisions, LocalScripts and ModuleScripts, and more. The entire game exported.")
                            .font(.system(size: 9))
                            .multilineTextAlignment(.leading)
                            .frame(width: 120)
                        
                        HStack {
                            Toggle("", isOn: $decompileScripts)
                                .toggleStyle(.checkbox)
                                .labelsHidden()
                            Text("decompile scripts")
                                .font(.system(size: 11))
                                .foregroundColor(Color(white: 0.36))
                        }
                    }
                    .padding(10)
                    .background(Color(white: 0.95))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(white: 0.88), lineWidth: 2)
                    )
                    
                    // Middle column
                    VStack(spacing: 8) {
                        UtilityButton(title: "Infinite Yield", imageName: "IYlight", height: 70)
                        UtilityButton(title: "RemoteSpy", imageName: "filter", height: 70)
                        UtilityButton(title: "Open Workspace Folder", imageName: "workspace", height: 74)
                    }
                    
                    // Right column
                    VStack(spacing: 8) {
                        UtilitySmallButton(title: "Unlock FPS")
                        UtilitySmallButton(title: "Stream Sniper")
                        UtilityOwlHubButton()
                        
                        Spacer()
                        
                        // About section
                        VStack {
                            Image("azulttag")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                            
                            Text("Script-Ware M")
                                .font(.custom("Times New Roman", size: 14))
                                .italic()
                            
                            Text("Created by Inspect. Thanks to\nAzuLX, Moon, cook, Cammy,\nSigma, deima, and doot.\nRemake by Marcus Nguyen\nAPI by Raptor LLC")
                                .font(.system(size: 8))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 450, height: 260)
        .fixedSize()
    }
}

struct UtilityButton: View {
    let title: String
    let imageName: String
    let height: CGFloat
    
    var body: some View {
        Button(action: {}) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                if !title.isEmpty {
                    Text(title)
                        .font(.system(size: 12))
                }
            }
            .frame(width: 130, height: height)
            .background(Color(white: 0.95))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(white: 0.88), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct UtilitySmallButton: View {
    let title: String
    
    var body: some View {
        Button(action: {}) {
            Text(title)
                .font(.system(size: 12))
                .frame(width: 130, height: 30)
                .background(Color(white: 0.95))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(white: 0.88), lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
    }
}

struct UtilityOwlHubButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Image("owlhub")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                Text("Owl Hub")
                    .font(.system(size: 12))
            }
            .frame(width: 130, height: 30)
            .background(Color(white: 0.95))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(white: 0.88), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UtilitiesView(isPresented: .constant(true), tabManager: TabManager())
}
