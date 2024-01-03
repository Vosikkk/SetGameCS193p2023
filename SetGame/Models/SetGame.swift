//
//  SetGame.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import Foundation

protocol Matchable {
    static func match(cards: [Self]) -> Bool
}

struct SetGame<Content> where Content: Matchable {
    
    private(set) var cards: [Card] = []
    private(set) var deck: [Card] = []
    
    
    let numberOfCardsToMatch = 3
    var numberOfCardsToStart = 12
    
    private var selectedIndices: [Int] {
        cards.indices.filter { cards[$0].isSelected }
    }
    
    private var matchedIndices: [Int] {
        cards.indices.filter { cards[$0].isSelected && cards[$0].isMatched }
    }
    
    
    init(numberOfCardsToStart: Int, numberOfCardsInDeck: Int, cardContentFactory: (Int) -> Content) {
        cards = []
        deck = []
        self.numberOfCardsToStart = numberOfCardsToStart
        for index in 0..<numberOfCardsInDeck {
            let content = cardContentFactory(index)
            deck.append(Card(content: content, id: index))
        }
        deck.shuffle()
    }
    
    
    mutating func deal(_ numberOfCards: Int? = nil) {
        let amount = numberOfCards ?? numberOfCardsToStart
        for _ in 0..<amount {
            cards.append(deck.remove(at: 0))
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.getIndex(matching: card), !cards[chosenIndex].isSelected, !cards[chosenIndex].isMatched {
           
            // Chosen 2 cards
            if selectedIndices.count == 2 {
                cards[chosenIndex].isSelected = true
                
                if Content.match(cards: selectedIndices.map { cards[$0].content }) {
                    // Matched
                    for index in selectedIndices {
                        cards[index].isMatched = true
                    }
                } else {
                    // Not matched
                    for index in selectedIndices {
                        cards[index].isNotMatched = true
                    }
                }
            } else {
                // other count of selected
                if selectedIndices.count == 1 || selectedIndices.count == 0 {
                    cards[chosenIndex].isSelected = true
                } else {
                    changeCards()
                    onlySelectedCard(chosenIndex)
                }
                
            }
        }
    }
    
    private mutating func onlySelectedCard(_ chosenIndex: Int) {
        for index in cards.indices {
            cards[index].isSelected = index == chosenIndex
            cards[index].isNotMatched = false
        }
    }
    
    
    private mutating func changeCards() {
        guard matchedIndices.count == numberOfCardsToMatch else { return }
        let replaceIndices = matchedIndices
        
        if deck.count >= numberOfCardsToMatch && cards.count == numberOfCardsToStart {
            // replace
            for index in replaceIndices {
                cards.remove(at: index)
                cards.insert(deck.remove(at: 0), at: index)
            }
        } else {
            // remove
            cards = cards.enumerated()
                .filter { !replaceIndices.contains($0.offset) }
                .map { $0.element }
        }
    }
    
    
    struct Card: Identifiable {
        var isSelected: Bool = false
        var isMatched: Bool = false
        var isNotMatched: Bool = false
        var content: Content
        var id: Int
    }
    
    
}

extension Array where Element: Identifiable {
    func getIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
