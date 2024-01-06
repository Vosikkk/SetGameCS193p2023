//
//  Cardify.swift
//  SetGame
//
//  Created by Саша Восколович on 04.01.2024.
//

import SwiftUI


struct CardModifier: ViewModifier, Animatable {
    
    var animatableData: Double {
        0
    }
    
    var isSelected: Bool
    var settings: Setting
    var state: SetGame<SetCard>.CardState
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: cornerRadius)
            base.strokeBorder(highlightColor(), lineWidth: borderLineWidth)
                .background(base.fill(state == .hint ? settings.colorHint : .white))
                .overlay(content)
        }

    }
    
    private func highlightColor() -> Color {
        var color: Color = .white.opacity(0)
        if isSelected {
            switch state {
            case .normal:
                color = settings.colorsBorder[2]
            case .matched:
                color = settings.colorsBorder[0]
            case .notMatched:
                color = settings.colorsBorder[1]
            default: break
            }
        }
        return color
    }
    
    private let cornerRadius: CGFloat = 10
    private let borderLineWidth: CGFloat = 5
}

extension View {
    func cardMod(isSelected: Bool, settings: Setting,  state: SetGame<SetCard>.CardState ) -> some View {
        modifier(CardModifier(isSelected: isSelected, settings: settings, state: state))
    }
}
