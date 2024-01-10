//
//  SetCardGameView.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import SwiftUI

struct SetCardGameView: View {
   
    typealias Card = SetGame<SetCard>.Card
    
    @ObservedObject var setGame: SetCardGame
    
    @Namespace private var dealingNamesSpace
    
    @State var count = 0
    
    
    var body: some View {
        VStack {
            HStack {
                deckCountLabel
                Spacer()
            }
            cards
            HStack() {
                hintButton
                Spacer()
                deck
                Spacer()
                newGameButton
            }
        }
        .foregroundStyle(.white)
        .font(.headline)
        .padding()
        .background(setGame.colorOfMainTheme.ignoresSafeArea(.all))
    }
        
    
    private var cards: some View {
            AspectVGrid(items: setGame.cards, aspectRatio: Constants.aspectRatio) { card in
                if isDealt(card) {
                    CardView(card: card, settings: $setGame.settings)
                        .matchedGeometryEffect(id: card.id, in: dealingNamesSpace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .padding(Constants.spasing)
                        
                        .onTapGesture {
                            setGame.choose(card: card)
                        }
                }
            }
    }
    
    
    private var deckCountLabel: some View {
        Text("Deck: \(setGame.cardsInDeck)")
            .animation(nil)
    }
    
    private var hintButton: some View {
        Button(setGame.hintCount) {
            setGame.hint()
        }
        .greenButton()
    }
    
    private var dealButton: some View {
        Button("Deal+3") {
            getThree()
        }
        .greenButton()
        .disabled(setGame.cardsInDeck == 0)
        .foregroundStyle(setGame.cardsInDeck == 0 ? .gray : .white)
    }
    
    private var newGameButton: some View {
        Button("New Game") {
           newGame()
        }
        .greenButton()
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in setGame.cards {
            withAnimation(.easeInOut(duration: 1).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            
            delay += 0.15
        }
    }

    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card: card, settings: $setGame.settings)
                    .matchedGeometryEffect(id: card.id, in: dealingNamesSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: 50, height: 50 / Constants.aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private var undealtCards: [Card] {
        setGame.deckCards.filter { !isDealt($0) }
    }
    
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    @State private var dealt: Set<Card.ID> = []
    
    private func getThree() {
        withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5)) {
            setGame.giveThreeCards()
        }
    }
    
    private func newGame() {
        setGame.newGame()
        deal()
    }
   
    
    private struct Constants {
        static let aspectRatio: CGFloat = 2/3
        static let spasing: CGFloat = 4
        static let cardTrasitionDelay: Double = 0.2
        
        struct DeckSize {
            static let width: CGFloat = 50
        }
    }
}


#Preview {
    SetCardGameView(setGame: SetCardGame())
}
