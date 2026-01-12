//
//  ContentView.swift
//  Script-Ware
//
//  Created by Nguyen Nam on 11/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginView()
            .environmentObject(AppState())
    }
}

#Preview {
    ContentView()
}
