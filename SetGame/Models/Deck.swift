//
//  Deck.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import Foundation


struct Deck {
    
    private(set) var deck: [Card] = []
    
    init() {
        for number in Card.Variant.allCases {
            for color in Card.Variant.allCases {
                for shape in Card.Variant.allCases {
                    for fill in Card.Variant.allCases {
                        deck.append(Card(number: number, color: color, shape: shape, fill: fill))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    
    mutating func draw() -> Card? {
        deck.count > 0 ? deck.remove(at: Int.random(in: 0..<deck.count)) : nil
    }
}
