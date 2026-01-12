//
//  LoginView.swift
//  Script-Ware
//
//  Created by Nguyen Nam on 11/1/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var username = ""
    @State private var password = ""
    @State private var rememberLogin = false
    @State private var errorMessage = ""
    
    // Correct colors from Electron version
    private let bgColor = Color(red: 0x1A/255, green: 0x1A/255, blue: 0x1A/255) // #1A1A1A
    private let textboxBg = Color(red: 0x14/255, green: 0x14/255, blue: 0x14/255) // #141414
    private let textboxBorder = Color(red: 0x2D/255, green: 0x2D/255, blue: 0x2D/255) // #2D2D2D
    
    var body: some View {
        VStack(spacing: 8) {
            // Logo
            Image("AppLogo")
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: 150)
            
            Text("Script-Ware")
                .font(.custom("Times New Roman", size: 14))
                .italic()
                .foregroundColor(Color(white: 0.42))
            
            // Username field
            TextField("username", text: $username)
                .textFieldStyle(.plain)
                .padding(8)
                .background(textboxBg)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(textboxBorder, lineWidth: 1.5)
                )
                .foregroundColor(.white)
                .frame(width: 200)
            
            // Password field
            SecureField("password", text: $password)
                .textFieldStyle(.plain)
                .padding(8)
                .background(textboxBg)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(textboxBorder, lineWidth: 1.5)
                )
                .foregroundColor(.white)
                .frame(width: 200)
            
            // Login button
            Button(action: login) {
                Text("Login")
                    .frame(width: 200)
                    .padding(.vertical, 6)
                    .background(Color(white: 0.2))
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            .buttonStyle(.plain)
            
            // Remember login checkbox
            HStack {
                Toggle("", isOn: $rememberLogin)
                    .toggleStyle(.checkbox)
                    .labelsHidden()
                Text("remember login")
                    .font(.system(size: 11))
                    .foregroundColor(Color(white: 0.36))
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.custom("Courier New", size: 11))
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Text("© 2026 Script-Ware")
                .font(.system(size: 12))
                .foregroundColor(Color(white: 0.88))
                .padding(.bottom, 8)
        }
        .padding()
        .frame(width: 250, height: 500)
        .background(bgColor)
    }
    
    func login() {
        appState.username = username
        appState.isLoggedIn = true
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
