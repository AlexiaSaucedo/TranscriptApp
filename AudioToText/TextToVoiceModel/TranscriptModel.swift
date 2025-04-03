//
//  TranscriptModel.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 16/12/24.
//

import Foundation

struct TranscriptModel: Codable {
    let transcription:  TranscriptionData
}

struct TranscriptionData: Codable {
    let task: String 
    let language: String
    let text: String
    let segments: [Segment]
}

struct Segment: Codable, Identifiable {
    let id: Int
    let start: Double
    let end: Double
    let text: String
}

// Version for UI
struct TranscriptSegment: Identifiable {
    let id = UUID()
    let text: String
    let timestamp: TimeInterval
    
    init(text: String, timestamp: TimeInterval){
        self.text = text
        self.timestamp = timestamp
    }

    init(from apiSegment: Segment){
        self.text = apiSegment.text
        self.timestamp = apiSegment.start
    }
}
