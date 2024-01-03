//
//  SetCardGame.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import Foundation

class SetCardGame: ObservableObject {
    
    typealias Game = SetGame<SetCard>
    typealias Card = Game.Card
    
    @Published private var game: Game = SetCardGame.createGame()
    
    static func createGame() -> Game {
        Game(numberOfCardsToStart: numberOfCardsToStart, numberOfCardsInDeck: deck.cards.count) { index in
            deck.cards[index]
        }
    }
    
    static var numberOfCardsToStart = 12
    static private var deck = Deck()
    
    
    
    var cards: [Card] {
        game.cards
    }
    
    // MARK: - Intent
    
    func choose(card: Card) {
        game.choose(card: card)
    }
    
    func deal() {
        game.deal()
    }
    
}
