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


enum TranscriptError: LocalizedError {
    case invalidURL
    case fileNotFound(URL)
    case fileAccessDenied(URL)
    case invalidFileData(URL)
    case networkError(String)
    case decodingError(String)

    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The API endpoint is invalid"
            case .fileNotFound(let url):
                return "Audio file not found at location: \(url.lastPathComponent)"
            case .fileAccessDenied(let url):
                return "Permission denied to access file: \(url.lastPathComponent)"
            case .invalidFileData(let url):
                return "Could not read data from file: \(url.lastPathComponent)"
            case .networkError(let message):
                return "Network error occurred: \(message)"
            case .decodingError(let message):
                return "Failed to process server response: \(message)"
        }
    }
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
    
    func uploadAudio(from url: URL) async throws -> [Segment]{
        let apiUrl = "http://localhost:3000/transcribe"
        
        guard let endpoint = URL(string: apiUrl) else {
            throw TranscriptError.invalidURL
        }
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw TranscriptError.fileNotFound(url)
        }

         // Start accessing the security-scoped resource
        guard url.startAccessingSecurityScopedResource() else {
            throw TranscriptError.fileAccessDenied(url)
        }
        defer { url.stopAccessingSecurityScopedResource() }

        do {
            print("Attempting to read file at: \(url.path)")
            let fileData = try Data(contentsOf: url)
            print("Successfully read file data of size: \(fileData.count) bytes")
            return try await withCheckedThrowingContinuation { continuation in 
                AF.upload(multipartFormData: { multipartFormData in 
                    multipartFormData.append(
                        fileData,
                        withName: "audio", 
                        fileName: url.lastPathComponent,
                        mimeType: url.mimeType()
                    )
                }, to: endpoint, method: .post)
                .responseDecodable(of: TranscriptModel.self) { response in
                    switch response.result {
                        case .success(let transcriptModel):
                            continuation.resume(returning: transcriptModel.transcription.segments)
                        case .failure(let error):
                            continuation.resume(throwing: TranscriptError.networkError(error.localizedDescription))
                    }
                }

            }
        } catch let error as NSError {
            switch error.code {
                case NSFileReadCorruptFileError:
                    throw TranscriptError.invalidFileData(url)
                default: 
                    throw TranscriptError.invalidFileData(url)
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
    
}
