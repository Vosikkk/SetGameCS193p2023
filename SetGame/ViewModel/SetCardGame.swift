//
//  SetCardGame.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import SwiftUI

class SetCardGame: ObservableObject {
    
    typealias Game = SetGame<SetCard>
    typealias Card = Game.Card
    
    var settings: Setting
    
    static private var deck = Deck()
    
    @Published private var game: Game
    
    
    static func createGame() -> Game {
        return Game(numberOfCardsToStart: numberOfCardsToStart, numberOfCardsInDeck: deck.cards.count) { index in
            deck.cards[index]
        }
    }
    
    
    init() {
        settings = Setting()
        game = SetCardGame.createGame()
    }
    
    static var numberOfCardsToStart = 12
   
    var colorOfMainTheme: Color {
        settings.tableColor
    }
    
    var cardsInDeck: Int {
        game.deck.count
    }
    
    var deckCards: [Card] {
        game.deck
    }
    
    
    var cards: [Card] {
        game.cardsOnTheTable
    }
    
    
    var hintCount: String {
        "Hints: \(game.hints.count) / \(game.hintsCount + 1)"
    }
    
    
    // MARK: - Intent
    
    func choose(card: Card) {
        game.choose(card: card)
    }
    
    func deal() {
        game.deal()
    }
    
    func flipCardToFaceUp(card: Card) {
        game.flipCard(card: card)
    }
    
    func newGame() {
        game = SetCardGame.createGame()
    }
    
    func giveThreeCards() {
        game.deal(3)
    }
    
    func hint() {
        game.hint()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.game.disHint()
        }
    }
}

struct Setting {
    
    let colorsShape: [Color] = [.red, .green, .purple]
    let colorsBorder: [Color] = [#colorLiteral(red: 0.1940105259, green: 0.003823338309, blue: 0.9934375882, alpha: 1),#colorLiteral(red: 0.9955675006, green: 0.001091319602, blue: 0.1432448924, alpha: 1),#colorLiteral(red: 0.9914981723, green: 0.9005147815, blue: 0.01922592521, alpha: 1)].map { Color($0) }
    
    let fillForShapes = [FillInSet.stroke, .stripe, FillInSet.fill]
    
    let shapes = [ShapesInSet.diamond, .oval, .squiggle]
    
    let colorHint: Color = Color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1))
    
    let tableColor: Color = Color(UIColor(red: 0, green: 0.5, blue: 0, alpha: 1))
    
    let deckColor: Color = .purple
    
    enum FillInSet: Int, CaseIterable {
        case stroke = 1
        case fill
        case stripe
       // case blur
    }
    
    enum ShapesInSet: Int, CaseIterable {
            case diamond = 1
            case oval
            case squiggle
           // case rainDrop
    }
}
