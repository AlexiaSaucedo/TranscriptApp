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
            ContentView().preferredColorScheme(.light)
            //AudioPlayerView()
        }
       .windowResizability(.contentSize)
       #endif
       
       WindowGroup {
           ContentView()
       }
    }
}
