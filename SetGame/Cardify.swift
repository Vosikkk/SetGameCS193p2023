//
//  Cardify.swift
//  SetGame
//
//  Created by Саша Восколович on 04.01.2024.
//

import SwiftUI


struct Cardify: ViewModifier, Animatable {
    
    var animatableData: Double {
        0
    }
    
    var isMatched: Bool
    var isSelected: Bool
    var isNotMatched: Bool
    var settings: Setting
    
    var colorsBorder: [Color] = [.blue, .red, .yellow]
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: cornerRadius)
            base.strokeBorder(highlightColor(), lineWidth: borderLineWidth)
                .background(base.fill(.white))
                .overlay(content)
        }

    }
    
    private func highlightColor() -> Color {
        var color: Color = .white.opacity(0)
        if isSelected {
            if isMatched {
                color = settings.colorsBorder[0]
            } else if isNotMatched {
                color = settings.colorsBorder[1]
            } else {
                color = settings.colorsBorder[2]
            }
        }
        return color
    }
    
    private let cornerRadius: CGFloat = 10
    private let borderLineWidth: CGFloat = 5
}

extension View {
    func cardify(isMatched: Bool, isSelected: Bool, isNotMatched: Bool, settings: Setting) -> some View {
        modifier(Cardify(isMatched: isMatched, isSelected: isSelected, isNotMatched: isNotMatched, settings: settings))
    }
}
