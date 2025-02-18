//
//  AudioPlayerView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 22/08/24.
//

import SwiftUI

struct AudioPlayerView: View {
    
    @StateObject private var audioPlayerViewModel = AudioPlayerViewModel()
    var audioPath: URL?
    
    var body: some View {
        VStack{
            //Just show when there is a transcription
            TranscriptView()
            
            VStack{
                //Slider
                Slider(value: Binding(get: {audioPlayerViewModel.currentTime}, set: {
                    newValue in audioPlayerViewModel.seekAudio(to: newValue)}),
                       in: 0...audioPlayerViewModel.totalTime)
                .controlSize(.mini)
                
                //Time Stamps
                HStack{
                    Text(audioPlayerViewModel.timeString(time: audioPlayerViewModel.currentTime)).foregroundStyle(.gray)
                    Spacer()
                    Text(audioPlayerViewModel.timeString(time: audioPlayerViewModel.totalTime)).foregroundStyle(.gray)
                }
            }.padding()
            
            HStack{
                Button(action:{print("10 seconds before")}) {
                    Image(systemName: "gobackward.10").frame(width: 24, height: 24)
                }.buttonStyle(.borderless).padding().foregroundStyle(.gray)
                
                Button(action: {
                    audioPlayerViewModel.playOrPause()
                }){
                    Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }.buttonStyle(.borderless).foregroundStyle(.gray)
                
                Button(action:{print("10 before")}) {
                    Image(systemName: "goforward.10").frame(width: 24,height: 24)
                }.buttonStyle(.borderless).padding().foregroundStyle(.gray)
            }
            
            
        }
        .onAppear{
            audioPlayerViewModel.loadAudioFile(named: "french")
            print(audioPath ?? "No URL from File Browser")
        }
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()){
            _ in audioPlayerViewModel.updateProgress()
        }
        .background{
            Color.white
        }
    }
}

#Preview {
    AudioPlayerView()
}
