//
//  AudioPlayerView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 22/08/24.
//

import SwiftUI

struct AudioPlayerView: View {
    //New Variables
    //@Binding var expandSheet: Bool
    //var animation: Namespace.ID
    @State private var animationContent: Bool = false
    
    @StateObject private var audioPlayerViewModel = AudioPlayerViewModel()
    @State private var transcriptManager = TranscriptManager()
    
    var body: some View {
        VStack{
            TranscriptView()
            Button(action: {
                audioPlayerViewModel.playOrPause()
            }){
                Image(systemName: audioPlayerViewModel.isPlaying ? "pause.circle" : "play.circle")
                    .resizable()
                    .frame(width: 64, height: 64)
            }
            
            Slider(value: Binding(get: {audioPlayerViewModel.currentTime}, set: {
                newValue in audioPlayerViewModel.seekAudio(to: newValue)}),
                   in: 0...audioPlayerViewModel.totalTime)
            .foregroundColor(.white)
            
            HStack{
                Text(audioPlayerViewModel.timeString(time: audioPlayerViewModel.currentTime))
                Spacer()
                Text(audioPlayerViewModel.timeString(time: audioPlayerViewModel.totalTime))
            }
            
        }
        .onAppear{
            audioPlayerViewModel.loadAudioFile(named: "french")
            transcriptManager.fetchTranscript()
            //transcriptManager.sendPostRequest(filename: "french")
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()){
            _ in audioPlayerViewModel.updateProgress()
        }
    }
}

#Preview {
    AudioPlayerView()
}
