//
//  Transcript.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 02/10/24.
//

import Foundation
import SwiftUI
import Alamofire
import UniformTypeIdentifiers

extension URL {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}


enum TranscriptError: Error {
    case invalidURL
    case invalidResponse
}

/* curl example from OpenAI for the whisper Model  */
class TranscriptManager {
    
    @State var multipart = MultipartRequest()
   
    static let shared = TranscriptManager()
    
    // Instance of a URLSession as Singleton
    private let session: URLSession
    
    init() {
        let config =  URLSessionConfiguration.background(withIdentifier: "uploadMP3")
        session = URLSession(configuration: config)
    }
    
    let apiURL = "http://localhost:3000/transcribe"
    
    func getMessage(){
        let url = "http://localhost:3000/msg"
        
        guard let url = URL(string: url) else {
            return
        }
        
        AF.request(url, method: .get).response{ response in
            guard let data = response.data else {
                return
            }
            print(String(decoding:data, as:UTF8.self))
        }
        
    }
    
    func uploadAudio(named filename: String){
        let url = "http://localhost:3000/transcribe"
        
        guard let url = URL(string: url) else {
            return
        }
        
        //File Handle
        let filePath = Bundle.main.url(forResource: filename, withExtension: "mp3")
        let mimeType = filePath?.mimeType()
        let fileData = try? Data(contentsOf: filePath!)
        
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData ?? Data(), withName: "audio", fileName: "\(filename).mp3", mimeType: mimeType ?? "")
        }, to: url, method: .post)
        .response{
            response in
            if let data = response.data {
                print(String(decoding: data, as:UTF8.self))
            }
            else {
                print("Something went wrong")
            }
        }
    }
    
    
    func fetchTranscript() async throws {
        guard let url = URL(string: apiURL) else {
            print("Bad Url")
            throw TranscriptError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        
        multipart.add(key: "audio", fileName: "french.mp3", fileMimeType: "audio/mpeg", fileData: "french.mp3".data(using: .utf8)!)
        
        request.httpBody = multipart.httpBody
        
        let task = session.uploadTask(withStreamedRequest: request)
        task.resume()
    }
     
    
    func getTranscript(completion: @escaping (String?, Error?) -> (Void)){
        
            if let url = URL(string: apiURL){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
                
                multipart.add(key: "audio", fileName: "french.mp3", fileMimeType: "audio/mpeg", fileData: "french.mp3".data(using: .utf8)!)
                
                request.httpBody = multipart.httpBody
                
                // uploadTask -> uploadFile
                let task = session.uploadTask(withStreamedRequest: request)
                task.resume()
        
            }
    
    
// CLOSURE
//    {(data: Data?, response: URLResponse?, error: Error?) in
//        
//        // Response situations
//        if let error = error {
//            print("Error", error)
//            return
//        }
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            print("not the right response")
//            return
//        }
//        
//        guard (200...299).contains(httpResponse.statusCode) else {
//            print("Error, status code", httpResponse.statusCode)
//            return
//        }
//        
//        guard let data = data else {
//           print("bad data")
//            return
//        }
//        
//        do {
//            let str = String(data: data, encoding: .utf8)
//            print(str ?? "")
//            DispatchQueue.main.async{
//                completion(str, nil)
//            }
//        }
//    }

    }
    
}
