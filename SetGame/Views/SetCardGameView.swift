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
    
    @State var firstDeal: Bool = true
    
    
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
        .foregroundStyle(.secondary)
        .font(.headline)
        .padding()
        .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1)),
                        Color(UIColor(red: 0, green: 1, blue: 0, alpha: 1))
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 500
                )
                .ignoresSafeArea()
            )
        // .background(setGame.colorOfMainTheme.ignoresSafeArea(.all))
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
        firstDeal ? setGame.deal() : setGame.giveThreeCards()
        
        var delay: TimeInterval = 0
        
        for card in setGame.cards {
              withAnimation(.easeInOut(duration: 1).delay(delay)) {
                _ = dealt.insert(card.id)
                  withAnimation(.easeInOut(duration: 0.5).delay(delay * 2)) {
                      setGame.flipCardToFaceUp(card: card)
                  }
            }
           
            delay += 0.15
        }
        firstDeal = false
    }

        
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card: card, settings: $setGame.settings)
                    .matchedGeometryEffect(id: card.id, in: dealingNamesSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                   
            }
        }
        .frame(width: Constants.DeckSize.width, height: Constants.DeckSize.width / Constants.aspectRatio)
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
//        dealt = []
//        deal()
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
