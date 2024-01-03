//
//  SetCardGameView.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import SwiftUI

struct SetCardGameView: View {
   
    @StateObject var setGame = SetCardGame()
    
    private let aspectRatio: CGFloat = 2/3
    private let spasing: CGFloat = 4
    
    var body: some View {
        AspectVGrid(items: setGame.cards, aspectRatio: aspectRatio) { card in
            CardView(card: card)
                .onTapGesture {
                    setGame.choose(card: card)
                }
                .padding(spasing)
              
        }
        .onAppear {
            setGame.deal()
        }
        .padding()
        .background(tableColor.ignoresSafeArea(.all))
    }
    
    private var tableColor: Color {
        Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1))
    }
}


struct CardView: View {
    
    typealias Card = SetGame<SetCard>.Card
    
    var colorsBorder: [Color] = [.blue, .red, .yellow]
    
    var card: Card
    
    var body: some View {
        if card.isSelected || !card.isMatched {
            SetCardView(card: card.content)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(highkightColor(), lineWidth: borderLineWidth)
                    )
        }
    }
    
    
    private func highkightColor() -> Color {
        var color: Color = .white.opacity(0)
        if card.isSelected {
            if card.isMatched {
                color = colorsBorder[0]
            } else if card.isNotMatched {
                color = colorsBorder[1]
            } else {
                color = colorsBorder[2]
            }
        }
        return color
    }
    
    private let cornerRadius: CGFloat = 10
    private let borderLineWidth: CGFloat = 5
}



#Preview {
    SetCardGameView()
}
