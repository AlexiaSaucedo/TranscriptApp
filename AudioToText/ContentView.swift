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
        
        FileInspectorView().preferredColorScheme(.light)
            .frame(maxWidth: .infinity)
            .padding([.vertical, .horizontal], 20)  
            .background(Color.backgroundLight)
    }
}

#Preview {
    ContentView()
}
