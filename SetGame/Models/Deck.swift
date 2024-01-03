//
//  Deck.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import Foundation


struct Deck {
    
    private(set) var deck: [SetCard] = []
    
    init() {
        for number in SetCard.Variant.allCases {
            for color in SetCard.Variant.allCases {
                for shape in SetCard.Variant.allCases {
                    for fill in SetCard.Variant.allCases {
                        deck.append(SetCard(number: number, color: color, shape: shape, fill: fill))
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    
    mutating func draw() -> SetCard? {
        deck.count > 0 ? deck.remove(at: Int.random(in: 0..<deck.count)) : nil
    }
}
