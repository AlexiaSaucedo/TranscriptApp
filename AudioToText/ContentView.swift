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
        NavigationView{
            List{
                NavigationLink("Play Now"){AudioPlayerView()}
                NavigationLink("New Transcript"){FileInspectorView()}
            }
        
        }.navigationTitle("Transcription App")
    }
}

#Preview {
    ContentView()
}
