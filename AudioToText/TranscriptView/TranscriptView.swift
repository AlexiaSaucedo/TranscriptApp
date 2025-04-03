//
//  TranscriptView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 10/09/24.
//  .onAppear{transcriptManager.uploadAudio(named: "french")}

import SwiftUI

struct TranscriptView: View {

    let audioURL: URL? //Required

    @State private var transcriptManager = TranscriptManager()
    // @StateObject var vm = CoreDataViewModel()
    @State private var showMenu: Bool = false
    @State private var hoveredSegmentId: Int? = nil
    @State private var errorMessage: String? = nil
    @State private var segments: [Segment] = []
    
//    @State private var segments: [TranscriptSegment] = [
//         TranscriptSegment(text: "Oui, j'avoue que moi non plus, je n'irais pas vraiment le voir au cinéma", timestamp: 0.0),
//         TranscriptSegment(text: "parce que pour moi, c'est un film, comme tu dis, qu'on regarde chez soi,", timestamp: 1.5),
//    ]
    
    //Scroll to Top
    @Namespace var topID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
//                Image(systemName: "house.fill").padding([.top],10).id(topID)
                if let error = errorMessage {
                    Text(error)
                    .foregroundStyle(.red)
                    .padding()
                } else {
                    VStack(spacing: 22){
                        ForEach(segments) { segment in
                            VStack(spacing: 10) {
                                Text(segment.text)
                                    .fontWeight(.semibold)
                                    .font(.title)
                                    .foregroundStyle(.gray)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(10)
                                
                                if hoveredSegmentId == segment.id {
                                    TextMenu()
                                }
                                
                            }
                            .padding(.vertical, 10)
                            .onHover { isHovered in
                                hoveredSegmentId = isHovered ? segment.id : nil
                            }
                        }
                        
                    }
                }

                
//                Button("Scroll to Top"){
//                    withAnimation{
//                        proxy.scrollTo(topID)
//                    }
//                }.padding()
            }.frame(maxWidth: .infinity)
        }
        .frame(width: 560)
        .task {
            await loadTranscript()
        }
    }

    private func loadTranscript() async {
        guard let url = audioURL else {
            errorMessage = "No audio file provided"
            return
        }

        do {
            segments = try await transcriptManager.uploadAudio(from: url)
        } catch let error as TranscriptError{
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }

}

extension Image {
    func menuIconModifier() -> some View {
        self
            .font(.system(size: 20))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.blueAccent)
    }
}

#Preview {
    TranscriptView(audioURL: URL(string: "/Users/alexiasau/IOS Dev /AudioToText/AudioToText/french.mp3")).preferredColorScheme(.light)
        .frame(maxWidth: .infinity)
        .frame(height: 600)
        .background(Color.backgroundLight)
}

struct TextMenu: View {
    var body: some View {
        HStack(spacing: 18){
            Image(systemName: "play.circle.fill")
                .menuIconModifier()
            
            Image(systemName: "character.book.closed.fill")
                .menuIconModifier()
            
            Image(systemName: "bubble.left.and.text.bubble.right.fill")
                .menuIconModifier()
        }
    }
}
