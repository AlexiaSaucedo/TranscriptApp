//
//  ContentView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 11/08/24.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Button("Open Audio Player") {
            openWindow(id: "player")
        }
    }
}

#Preview {
    ContentView()
}
