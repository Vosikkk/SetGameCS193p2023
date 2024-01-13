//
//  SetGame.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import Foundation

protocol Matchable {
    static func isSet(cards: [Self]) -> Bool
}

struct SetGame<Content> where Content: Matchable {
    
    private(set) var cardsOnTheTable: [Card] = []
    private(set) var deck: [Card] = []
    
    
    let numberOfCardsToMatch = 3
    var numberOfCardsToStart = 12
    
    private var selectedIndices: [Int] {
        cardsOnTheTable.indices.filter { cardsOnTheTable[$0].isSelected }
    }
    
    private var matchedIndices: [Int] {
        cardsOnTheTable.indices.filter { cardsOnTheTable[$0].isSelected && cardsOnTheTable[$0].state == .matched }
    }
    
    var hintsCount: Int = 0
    
    
    var hints: [[Int]] {
        
        var res: [[Int]] = []
        
        if cardsOnTheTable.count > 2 {
            for i in 0..<cardsOnTheTable.count - 2 {
                for j in (i+1)..<cardsOnTheTable.count - 1 {
                    for k in (j+1)..<cardsOnTheTable.count {
                        let check = [cardsOnTheTable[i], cardsOnTheTable[j], cardsOnTheTable[k]]
                        if Content.isSet(cards: check.map { $0.content }) {
                            res.append([i,j,k])
                        }
                    }
                }
            }
        }
        return res
    }
    
    
    
    
    init(numberOfCardsToStart: Int, numberOfCardsInDeck: Int, cardContentFactory: (Int) -> Content) {
        cardsOnTheTable = []
        deck = []
        self.numberOfCardsToStart = numberOfCardsToStart
        for index in 0..<numberOfCardsInDeck {
             let content = cardContentFactory(index)
                deck.append(Card(content: content))
            
        }
        deck.shuffle()
    }
    
    mutating func flipCard(card: Card) {
        if let cardForFlipIndex = cardsOnTheTable.getIndex(matching: card) {
            cardsOnTheTable[cardForFlipIndex].isFaceUp = true
        }
    }
    
    
    mutating func deal(_ numberOfCards: Int? = nil) {
        let amount = numberOfCards ?? numberOfCardsToStart
        for _ in 0..<amount {
            cardsOnTheTable.append(deck.remove(at: 0))
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cardsOnTheTable.getIndex(matching: card), !cardsOnTheTable[chosenIndex].isSelected, cardsOnTheTable[chosenIndex].state == .normal {
           
            // Chosen 2 cards
            if selectedIndices.count == 2 {
                cardsOnTheTable[chosenIndex].isSelected = true
                
                if Content.isSet(cards: selectedIndices.map { cardsOnTheTable[$0].content }) {
                    // Matched
                    for index in selectedIndices {
                        cardsOnTheTable[index].state = .matched
                    }
                } else {
                    // Not matched
                    for index in selectedIndices {
                        cardsOnTheTable[index].state = .notMatched
                    }
                }
            } else {
                // other count of selected
                if selectedIndices.count == 1 || selectedIndices.count == 0 {
                    cardsOnTheTable[chosenIndex].isSelected = true
                } else {
                    changeCards()
                    onlySelectedCard(chosenIndex)
                }
                
            }
            // Disselected card
        } else if let chosenIndex = cardsOnTheTable.getIndex(matching: card), cardsOnTheTable[chosenIndex].isSelected,
                  cardsOnTheTable[chosenIndex].state == .normal {
            cardsOnTheTable[chosenIndex].isSelected = false
        }
    }
    
    private mutating func onlySelectedCard(_ chosenIndex: Int) {
        for index in cardsOnTheTable.indices {
            cardsOnTheTable[index].isSelected = index == chosenIndex
            cardsOnTheTable[index].state = .normal
        }
    }
    
    
    private mutating func changeCards() {
        guard matchedIndices.count == numberOfCardsToMatch else { return }
        let replaceIndices = matchedIndices
        hintsCount = 0
        if deck.count >= numberOfCardsToMatch && cardsOnTheTable.count == numberOfCardsToStart {
            // replace
            for index in replaceIndices {
                cardsOnTheTable.remove(at: index)
                cardsOnTheTable.insert(deck.remove(at: 0), at: index)
            }
        } else {
            // remove
            cardsOnTheTable = cardsOnTheTable.enumerated()
                .filter { !replaceIndices.contains($0.offset) }
                .map { $0.element }
        }
    }
    
    
    mutating func hint() {
        if hints.count != 0 && hintsCount < hints.count {
            for index in hints[hintsCount] {
                cardsOnTheTable[index].state = .hint
            }
            hintsCount += 1
            hintsCount = hintsCount < hints.count ? hintsCount : 0
        }
    }
    
    mutating func disHint() {
        if hints.count != 0 {
            for index in 0..<cardsOnTheTable.count {
                cardsOnTheTable[index].state = .normal
            }
        }
    }
    
    
    struct Card: Identifiable {
        var isSelected: Bool = false
        var isFaceUp: Bool = false
        var state: CardState = .normal
        var content: Content
        let id = UUID()
    }
    enum CardState {
        case normal, matched, notMatched, hint
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
