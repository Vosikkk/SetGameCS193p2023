//
//  Card.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import Foundation


struct SetCard: CustomStringConvertible {
    
    // There are three variants of each property
    let number: Variant // how many symbols do we have
    let color: Variant // what color
    let shape: Variant // what shape
    let fill: Variant // empty, shaded, full
    
    
    enum Variant: Int, CaseIterable, CustomStringConvertible {
        case v1 = 1
        case v2
        case v3
        
        var description: String {
            String(self.rawValue)
        }
    }
    
    
    var description: String {
        "\(number) \(color) \(shape) \(fill)"
    }
}

extension SetCard: Matchable {
    
    static func match(cards: [SetCard]) -> Bool {
        guard cards.count == 3 else { return false }
        let sum = [
            cards.reduce(0, { $0 + $1.number.rawValue }),
            cards.reduce(0, { $0 + $1.color.rawValue }),
            cards.reduce(0, { $0 + $1.shape.rawValue }),
            cards.reduce(0, { $0 + $1.fill.rawValue })
        ]
        return sum.reduce(true, { $0 && ( $1 % 3 == 0)})
    }
}
