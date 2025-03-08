//
//  Transcript.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 02/10/24.
//

import Foundation

/* curl example from OpenAI for the whisper Model  */
struct TranscriptManager{
    
    var multipart = MultipartRequest()
    //var multipart : MultipartRequest
    
    let apiURL = "http://localhost:3000/transcribe";
    
    
    let openAiurl = "https://api.openai.com/v1/audio/transcriptions"
    
    let jsonPayload: [String : Any] = [
        "file": "@/Users/alexiasau/Downloads/french1.mp3",
        "model": "whisper-1"
    ]
    let filepayload = "file=@/Users/alexiasau/Downloads/french1.mp3".data(using: .utf8)
    let modelpayload = "model=whisper-1".data(using: .utf8)
    
//    func useModelWhisper(){
//        Task{
//            let pipe = try? await WhisperKit()
//            let transcription = try? await pipe!.transcribe(audioPath: "/Users/alexiasau/Downloads/french1.mp3")?.text
//            print(transcription)
//        }
//    }
    
    mutating func formBody(){
            multipart.add(key: "file", fileName: "french.mp3", fileMimeType: "mp3", fileData: "audio-file".data(using: .utf8)!)
//            multipart.add(key: "model", value: "whisper-1")
//            multipart.add(key: "response_format", value: "text")
            //self.multipart = multipart // you can do this since ModelOne conforms to SuperModel
        
//        multipart = multipart.add(key: "file", fileName: "french.mp3", fileMimeType: "mp3", fileData: "audio-file".data(using: .utf8)!)
//        multipart = multipart.add(key: "model", value: "whisper-1")
//        multipart = multipart.add(key: "response_format", value: "text")
    }
    
    mutating func fetchTranscript(){
        
            if let url = URL(string: apiURL){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
                
                multipart.add(key: "file", fileName: "french.mp3", fileMimeType: "mp3", fileData: "audio-file".data(using: .utf8)!)
                
                request.httpBody = multipart.httpBody
                
                let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    if let error = error {
                        print(error)
                    } else if let data = data {
                        let str = String(data: data, encoding: .utf8)
                        print(str ?? "")
                    }
                }
                task.resume()
            }
       
        
    }
    
}
