//
//  TranscriptView.swift
//  AudioToText
//
//  Created by Alexia Fernanda Saucedo Romero on 10/09/24.
//

import SwiftUI

//struct ZebraStripeRenderer: TextRenderer {
//    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
//        for (index, line) in layout.enumerated() {
//            if index.isMultiple(of: 2) {
//                context.opacity =
//            } else {
//                context.opacity = 0.5
//            }
//
//            context.draw(line)
//        }
//    }
//}

struct TranscriptView: View {
    var body: some View {
        VStack{
            Text("Oui, j'avoue que moi non plus, je n'irais pas vraiment le voir au cinéma parce que pour moi, c'est un film, comme tu dis, qu'on regarde chez soi, tranquille sur son canapé ou dans son lit quand on est un peu déprimé ou fatigué.")
                .fontWeight(.bold)
                .font(.title)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(10)
                .padding()
        }
    }
}

#Preview {
    TranscriptView()
}
