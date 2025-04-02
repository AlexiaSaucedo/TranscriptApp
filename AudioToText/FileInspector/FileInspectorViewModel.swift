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
 
    @Published var selectedFileURL: URL?
    
    func audioDirectoryPicked(_ url: URL) -> Void{
        let pathFile = url.relativePath
        if let mditem = MDItemCreate(nil, pathFile as CFString),
           let mdnames = MDItemCopyAttributeNames(mditem),
           let mdattrs = MDItemCopyAttributes(mditem, mdnames) as? [String:Any]{
            
            let fileType = mdattrs[kMDItemKind as String] as? String ?? "No Type"
            print("Item Kind: \(fileType)")
            
            if isValidMP3(url) {
                // Bookmark the URL for persistent access
                do {
                    let bookmarkData = try url.bookmarkData(
                        options: .minimalBookmark,
                        includingResourceValuesForKeys: nil,
                        relativeTo: nil
                    )
                    // Store the bookmark data and URL
                    self.selectedFileURL = url
                    UserDefaults.standard.set(bookmarkData, forKey: "audioBookmark")
                    print("Successfully bookmarked audio file")
                } catch {
                    print("Failed to create bookmark: \(error)")
                }
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
