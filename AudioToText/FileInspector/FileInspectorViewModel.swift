//
//  FileInspectorViewModel.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 26/01/25.
//

import Foundation
import CoreServices

class FileInspectorViewModel: ObservableObject{
    //Path
    var pathFile : String = ""
    
    // Get path from View
    func audioDirectoryPicked(_ url: URL) -> Void{
        pathFile = url.relativePath
        if let mditem = MDItemCreate(nil, pathFile as CFString),
           let mdnames = MDItemCopyAttributeNames(mditem),
           let mdattrs = MDItemCopyAttributes(mditem, mdnames) as? [String:Any]{
            
            //print(mdattrs)
            print("Item Kind: \(mdattrs[kMDItemKind as String] as? String ?? "No Type")")
            //print("Media Type: \(mdattrs[kMDItemMediaTypes as String] ?? "No Media")")
        }else{
            print("Can't get attributes for \(pathFile)")
        }
        
    }
    // Verify if the file is correct
    
    func checkMp3(_ type: String) -> Bool{
        if(type == "MP3 audio"){
            return true
        }
        return false
    }
    
    // When ready play in a Audio Player
//    func playAudioFile(_ path: URL) -> Void{
//        AudioPlayerView(audioPath: path)
//    }
}
