//
//  SetCardGameView.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import SwiftUI

struct SetCardGameView: View {
   
    typealias Card = SetGame<SetCard>.Card
    
    @StateObject var setGame = SetCardGame()
    @State private var shouldDelay: Bool = true
    
    private let aspectRatio: CGFloat = 2.0/3.0
    private let spasing: CGFloat = 4
    private let cardTrasitionDelay: Double = 0.2
    
   
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                AspectVGrid(items: setGame.cards, aspectRatio: aspectRatio) { card in
                    CardView(card: card, settings: $setGame.settings)
                        .transition(.cardTransition(size: geometry.size)) // Змініть анімацію
                       
                        
                        .onTapGesture {
                            setGame.choose(card: card)
                        }
                        .padding(spasing)
                }
            }
            .onAppear {
                deal()
            }
            HStack() {
                Text("Deck: \(setGame.cardsInDeck)")
                Spacer()
                Button("Deal+3") {
                    getThree()
                }.greenButtonFy()
                Spacer()
                Button("New Game") {
                   newGame()
                }.greenButtonFy()
            }
            .foregroundStyle(.white)
            .font(.headline)
        }
        .padding()
        .background(tableColor.ignoresSafeArea(.all))
    }
    
    
    private func deal() {
        setGame.deal()
    }
    
    private var tableColor: Color {
        Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1))
    }
    
    private func getThree() {
        setGame.giveThreeCards()
    }
    
    private func newGame() {
        setGame.newGame()
        deal()
    }
   
    private func transitionDelay(card: Card) -> Double {
        guard shouldDelay else { return 0 }
        return Double(setGame.cards.getIndex(matching: card)!) * cardTrasitionDelay
    }
    
}


struct CardView: View {
    typealias Card = SetGame<SetCard>.Card
    var card: Card
    @Binding var settings: Setting
   
    
    var body: some View {
        SetCardView(card: card.content, settings: settings)
            .cardify(isMatched: card.isMatched, isSelected: card.isSelected, isNotMatched: card.isNotMatched, settings: settings)
    }
}



#Preview {
    SetCardGameView()
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
extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .easeInOut(duration: duration).repeatForever(autoreverses: false)
    }
}
