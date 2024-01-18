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
                .transition(.scale)
                .shakeEffect(with: card.state == .notMatched ? 1 : 0, isEnabled: card.state != .normal)
                .zoomEffect(with: card.state == .matched ? 1 : 0)
    }
}

