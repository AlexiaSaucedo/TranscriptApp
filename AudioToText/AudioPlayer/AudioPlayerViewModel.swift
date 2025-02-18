//
//  File.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 22/08/24.
//
import Foundation
import AVFoundation

class AudioPlayerViewModel: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    @Published var isPlaying = false
    // New Variables
    @Published var totalTime: TimeInterval = 0.0
    @Published var currentTime: TimeInterval = 0.0
    
    
    func loadAudioFile(named filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3"){
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                totalTime = audioPlayer?.duration ?? 0.0
            } catch {
                print("AVAudioPlayer could not be instantiated.")
            }
        } else {
            print("Audio file could not be found.")
        }
    }

      func playOrPause() {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
          player.pause()
          isPlaying = false
        } else {
          player.play()
          isPlaying = true
        }
      }

    //New Function
    func playAudio(){
        audioPlayer?.play()
        isPlaying = true
    }
    
    func stopAudio(){
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func updateProgress(){
        guard let player = audioPlayer else { return }
        currentTime = player.currentTime
    }
    
    func seekAudio(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func timeString(time: TimeInterval) -> String{
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
    
}

