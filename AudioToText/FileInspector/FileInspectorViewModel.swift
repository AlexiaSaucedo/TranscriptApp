//
//  FileInspectorViewModel.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 26/01/25.
//

import Foundation
import CoreServices
import AVFoundation

class FileInspectorViewModel: ObservableObject{
    //Path
    @Published var selectedFileURL: URL?
    //var pathFile : String = ""
    
    // Get path from View
    func audioDirectoryPicked(_ url: URL) -> Void{
        let pathFile = url.relativePath
        if let mditem = MDItemCreate(nil, pathFile as CFString),
           let mdnames = MDItemCopyAttributeNames(mditem),
           let mdattrs = MDItemCopyAttributes(mditem, mdnames) as? [String:Any]{
            
            //print(mdattrs)
            //print("Media Type: \(mdattrs[kMDItemMediaTypes as String] ?? "No Media")")
            let fileType = mdattrs[kMDItemKind as String] as? String ?? "No Type"
            print("Item Kind: \(fileType)")
            
            if isValidMP3(url) {
                selectedFileURL = url
                print("Valid MP3 file selected.")
            } else {
                print("Invalid MP3 file.")
            }
        } else {
            print("Can't get attributes for \(pathFile)")
        }
        
    }
    
    // Verify correct Audio Format
    private func isValidMP3(_ url: URL) -> Bool {
        guard url.pathExtension.lowercased() == "mp3" else { return false }
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            let format = audioFile.fileFormat
            
            return format.sampleRate > 0 && format.channelCount > 0
        } catch {
            print("Error reading audio file: \(error.localizedDescription)")
            return false
        }
    }
    
}
