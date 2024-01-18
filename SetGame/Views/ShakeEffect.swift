//
//  ShakeEffect.swift
//  SetGame
//
//  Created by Саша Восколович on 18.01.2024.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    
    var amount: CGFloat = 10
    var shakePerUnit: Int = 3
    var animatableData: CGFloat
    var isEnabled: Bool = true
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        if isEnabled {
           return ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakePerUnit)), y: 0))
        } else {
            // We tap 4 card when have misMacthed, so we don't need this animation anymore
             return ProjectionTransform(CGAffineTransform.identity)
        }
    }
    
}


extension View {
    func shakeEffect(with force: CGFloat, isEnabled: Bool) -> some View {
        modifier(ShakeEffect(animatableData: force, isEnabled: isEnabled))
    }
}

