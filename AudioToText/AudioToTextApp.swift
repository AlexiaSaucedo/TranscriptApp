//
//  AudioToTextApp.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 11/08/24.
//

import SwiftUI

@main
struct AudioToTextApp: App {
    var body: some Scene {
        #if os(macOS)
       Window("Audio Player", id: "player") {
           AudioPlayerView()
       }
       .defaultSize(width: 500, height: 800)
       .windowResizability(.contentMinSize)
       #endif
       
       WindowGroup {
           ContentView()
       }
    }
}
