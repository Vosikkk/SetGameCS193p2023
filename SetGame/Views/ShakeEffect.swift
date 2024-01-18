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
    
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakePerUnit)), y: 0))
    }
    
}


extension View {
    func shakeEffect(with force: CGFloat) -> some View {
        modifier(ShakeEffect(animatableData: force))
    }
}

