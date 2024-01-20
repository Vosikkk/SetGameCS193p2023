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
    
    @State private var dealt: Set<Card.ID> = []
    
    @State var firstDeal: Bool = true
    
    
    // MARK: - UI elements
    
    var body: some View {
        VStack {
            HStack {
                deckCountLabel
                Spacer()
                hintButton
            }
            cards
                .overlay(FlyingText(text, isAnimationEnabled: shouldAnimateText))
            HStack {
                discardDeck
                Spacer()
                VStack(spacing: Constants.spacingForButtons) {
                    newGameButton
                    shuffleButton
                }
                Spacer()
                deck
            }
        }
        
        .onAppear {
            deal()
        }
        .foregroundStyle(.secondary)
        .font(.headline)
        .padding()
        .background(setGame.colorOfMainTheme
                   .ignoresSafeArea()
        )
    }
        
    
    private var cards: some View {
        AspectVGrid(items: setGame.cards, aspectRatio: Constants.aspectRatio) { card in
            if isDealt(card) {
                view(for: card)
                    .padding(Constants.spaсing)
                    .onTapGesture {
                        withAnimation {
                            setGame.choose(card: card)
                        } completion: {
                            if !onWayToTheTableCards.isEmpty {
                                cardsGoFromTheDeck()
                            }
                        }
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
    
    private var shuffleButton: some View {
        Button("Shuffle") {
            withAnimation(
                .interactiveSpring(
                    response: 1, dampingFraction: Constants.Animation.dampingFraction)) {
                        setGame.shuffle()
            }
        }
        .greenButton()
    }
    
    private var newGameButton: some View {
        Button("New Game") {
           newGame()
        }
        .greenButton()
    }
            
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                view(for: card)
            }
        }
        .frame(
            width: Constants.DeckSize.width,
            height: Constants.DeckSize.width / Constants.aspectRatio
        )
        .onTapGesture {
            deal()
        }
    }
   
    
    private var discardDeck: some View {
        ZStack {
            ForEach(setGame.discard) { card in
               view(for: card)
                .zIndex(zIndex(for: card))
            }
        }
        .frame(
            width: Constants.DeckSize.width,
            height: Constants.DeckSize.width / Constants.aspectRatio
        )
    }
    
    
    private func view(for card: Card) -> some View {
        CardView(card: card, settings: $setGame.settings)
            .matchedGeometryEffect(id: card.id, in: dealingNamesSpace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    // MARK: - Animations
    
    private func deal() {
        performDealAction()
        firstDeal = false
        cardsGoFromTheDeck()
    }
    
    
    func cardsGoFromTheDeck() {
        
        var delay: TimeInterval = 0
       
        for card in onWayToTheTableCards {
            // Cards go on the table
            withAnimation(
                .easeInOut(
                    duration: Constants.Animation.dealtDurantion).delay(delay)) {
                        _ = dealt.insert(card.id)
                        
                        // Cards rotate when go on the table :)
                        withAnimation(
                            .easeInOut(
                                duration: Constants.Animation.onWayDuration).delay(delay + Constants.Animation.delayOffset)) {
                                    
                                    setGame.flipCardToFaceUp(card: card)
                                }
                    }
            delay += Constants.Animation.delay
        }
    }
    
    
    // MARK: - Logic
    
    private var undealtCards: [Card] {
        setGame.deckCards.filter { !isDealt($0) }
    }
    
    private var onWayToTheTableCards: [Card] {
        setGame.cards.filter { !$0.isFaceUp }
    }
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    // first deal contains 12 cards then only three
    private func performDealAction() {
        firstDeal ? setGame.deal() : setGame.dealThree()
    }
    
    private func zIndex(for card: Card) -> Double {
        Double(setGame.discard.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var shouldAnimateText: Bool {
        setGame.isMatch || setGame.isNotMatch
    }
    
    var text: String {
        setGame.isMatch ? "Set🔥" : "Oh☹️"
    }
    
    private func newGame() {
        setGame.newGame()
        dealt = []
        firstDeal = true
        withAnimation {
            deal()
        }
    }
    
    
    // MARK: - Nested type
    
    private struct Constants {
        
        static let aspectRatio: CGFloat = 2/3
        static let spaсing: CGFloat = 4
        static let cardTrasitionDelay: Double = 0.2
        static let spacingForButtons: CGFloat = 10
        
        struct DeckSize {
            static let width: CGFloat = 50
        }
        
        struct Animation {
            static let delay: CGFloat = 0.15
            static let dealtDurantion: CGFloat = 1
            static let onWayDuration: CGFloat = 0.5
            static let delayOffset: CGFloat = 0.5
            static let dampingFraction: Double = 0.5
        }
    }
}


#Preview {
    SetCardGameView(setGame: SetCardGame())
}
