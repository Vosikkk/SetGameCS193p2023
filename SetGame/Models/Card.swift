//
//  Card.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import Foundation


struct Card: CustomStringConvertible {
   
    var description: String {
        "\(number) \(color) \(shape) \(fill)"
    }
    
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
}
