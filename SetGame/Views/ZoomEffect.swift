//
//  ZoomEffect.swift
//  SetGame
//
//  Created by Саша Восколович on 18.01.2024.
//

import SwiftUI

struct ZoomEffect: GeometryEffect {
    
    var scale: CGFloat = 1.3
    var animatableData: CGFloat
    
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let scaleFactor = 1 + (scale - 1) * abs(sin(animatableData * .pi))
        return ProjectionTransform(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
    }
}

extension View {
    func zoomEffect(with force: CGFloat) -> some View {
        modifier(ZoomEffect(animatableData: force))
    }
}
