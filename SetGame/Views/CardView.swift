//
//  CardView.swift
//  SetGame
//
//  Created by Саша Восколович on 06.01.2024.
//

import SwiftUI


struct CardView: View {
    typealias Card = SetGame<SetCard>.Card
    var card: Card
    @Binding var settings: Setting
   
    
    var body: some View {
            SetCardView(card: card.content, settings: settings)
                .cardMod(isSelected: card.isSelected, settings: settings, isFaceUp: card.isFaceUp, state: card.state)
//                .offset(y: card.state == .matched ? 1000 : 0)
//                .animation(.spin(duration: 1), value: card.state == .matched)
                .transition(.scale)
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}
