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
    
    
    func loadAudioFile(from url: URL) {
        do {
            // print("Attempting to load audio from URL: \(url)")
            // print("File exists: \(FileManager.default.fileExists(atPath: url.path))")
            
            // Try to access the file
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                totalTime = audioPlayer?.duration ?? 0.0
                
                // print("Successfully loaded audio file.")
            } else {
                print("Failed to access security-scoped resource")
            }
        } catch let error as NSError {
            print("AVAudioPlayer initialization failed with error:")
            print("Domain: \(error.domain)")
            print("Code: \(error.code)")
            print("Description: \(error.localizedDescription)")
            print("Underlying error: \(error.userInfo)")
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

