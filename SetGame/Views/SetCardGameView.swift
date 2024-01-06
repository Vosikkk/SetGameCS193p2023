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
    @State private var shouldDelay: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                deck
                Spacer()
            }
            cards
            .onAppear {
                deal()
            }
            HStack() {
                hintButton
                Spacer()
                dealButton
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
        GeometryReader { geometry in
            AspectVGrid(items: setGame.cards, aspectRatio: Constants.aspectRatio) { card in
                CardView(card: card, settings: $setGame.settings)
                    .transition(.cardTransition(size: geometry.size))
//                        .animation( Animation.easeInOut(duration: 1.00)
//                                                                  .delay(transitionDelay(card: card)))
                    .onTapGesture {
                        setGame.choose(card: card)
                    }
                    .padding(Constants.spasing)
            }
        }
    }
    
    
    private var deck: some View {
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
        withAnimation(.bouncy(duration: 0.7, extraBounce: 0.3)) {
            setGame.deal()
        }
    }

    
    private func getThree() {
        withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5)) {
            setGame.giveThreeCards()
        }
    }
    
    private func newGame() {
        setGame.newGame()
        deal()
    }
   
    private func transitionDelay(card: Card) -> Double {
        guard shouldDelay else { return 0 }
        return Double(setGame.cards.getIndex(matching: card)!) * Constants.cardTrasitionDelay
    }
    private struct Constants {
        static let aspectRatio: CGFloat = 2/3
        static let spasing: CGFloat = 4
        static let cardTrasitionDelay: Double = 0.2
    }
}


#Preview {
    SetCardGameView(setGame: SetCardGame())
}

extension AnyTransition {
    
    static func cardTransition(size: CGSize) -> AnyTransition {
        let insertion = AnyTransition.offset(flyFrom(for: size))
        let removal = AnyTransition.offset(flyTo(for: size))
            .combined(with: AnyTransition.scale(scale: 0.5))
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static func flyFrom(for size: CGSize) -> CGSize {
        CGSize(width: 0.0, height: size.height)
    }
    static func flyTo(for size: CGSize) -> CGSize {
        CGSize(width: CGFloat.random(in: -3 * size.width...3 * size.width),
               height: CGFloat.random(in: -2 * size.height...(-size.height)))
    }
}

