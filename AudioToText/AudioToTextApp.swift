//
//  AudioToTextApp.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 11/08/24.
// .defaultSize(width: 500, height: 800)

import SwiftUI

@main
struct AudioToTextApp: App {
    var body: some Scene {
        #if os(macOS)
        Window("Audio Player", id: "player") {
            //AudioPlayerView()
            ContentView()
        }
       .windowResizability(.contentSize)
       #endif
       
       WindowGroup {
           ContentView()
       }
    }
}
