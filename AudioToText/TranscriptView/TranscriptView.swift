//
//  TranscriptView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 10/09/24.
//  .onAppear{transcriptManager.uploadAudio(named: "french")}

import SwiftUI

// TODO: Animation
// Fetch Data

struct TranscriptView: View {
    @State private var transcriptManager = TranscriptManager()
    @StateObject var vm = CoreDataViewModel()
    
    //Scroll to Top
    @Namespace var topID
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
                Button("Get Transcript") {
                    transcriptManager.uploadAudio(named: "french")
                }
                Image(systemName: "house.fill").padding([.top],10).id(topID)

                VStack{
                    ForEach(0..<3){
                        i in
                        Text("Oui, j'avoue que moi non plus, je n'irais pas vraiment le voir au cinéma parce que pour moi, c'est un film, comme tu dis, qu'on regarde chez soi, tranquille sur son canapé ou dans son lit quand on est un peu déprimé ou fatigué.")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .padding()
                    }
                    
                }
                
                Button("Scroll to Top"){
                    withAnimation{
                        proxy.scrollTo(topID)
                    }
                }.padding()
            }.frame(maxWidth: .infinity).frame(height: 260)
        }
    }
}

#Preview {
    TranscriptView()
}
