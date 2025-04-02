//
//  TranscriptView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 10/09/24.
//  .onAppear{transcriptManager.uploadAudio(named: "french")}

import SwiftUI

struct TranscriptView: View {
    @State private var transcriptManager = TranscriptManager()
    @StateObject var vm = CoreDataViewModel()
    
    @State private var showMenu: Bool = false
    
    //Scroll to Top
    @Namespace var topID
        
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView{
//                Image(systemName: "house.fill").padding([.top],10).id(topID)

                VStack(spacing: 32){
                    ForEach(0..<4){
                        i in
                        Text("Oui, j'avoue que moi non plus, je n'irais pas vraiment le voir au cinéma parce que pour moi, c'est un film, comme tu dis, qu'on regarde chez soi, tranquille sur son canapé ou dans son lit quand on est un peu déprimé ou fatigué.")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                        
                        if showMenu {
                            TextMenu()
                        }
                    }
                    
                }.onHover(perform: { hover in
                    showMenu = hover
                })
                
                Button("Scroll to Top"){
                    withAnimation{
                        proxy.scrollTo(topID)
                    }
                }.padding()
            }.frame(maxWidth: .infinity)
        }
        .frame(width: 560)
    }
}

extension Image {
    func menuIconMoidifier() -> some View {
        self
            .font(.system(size: 20))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.blueAccent)
    }
}

#Preview {
    TranscriptView().preferredColorScheme(.light)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 100)
        .background(Color.backgroundLight)
}

struct TextMenu: View {
    var body: some View {
        HStack(spacing: 18){
            Image(systemName: "play.circle.fill")
                .menuIconMoidifier()
            
            Image(systemName: "character.book.closed.fill")
                .menuIconMoidifier()
            
            Image(systemName: "bubble.left.and.text.bubble.right.fill")
                .menuIconMoidifier()
        }
    }
}
