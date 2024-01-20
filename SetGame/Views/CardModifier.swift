    //
    //  Cardify.swift
    //  SetGame
    //
    //  Created by Саша Восколович on 04.01.2024.
    //

    import SwiftUI


    struct CardModifier: ViewModifier, Animatable {
        
        var animatableData: Double {
            get { rotation }
            set { rotation = newValue }
        }
        
        
        var rotation: Double
        var isFaceUp: Bool {
            rotation < 90
        }
        var isSelected: Bool
        var settings: Setting
        var state: SetGame<SetCard>.Card.CardState
        
        init(isFaceUp: Bool, isSelected: Bool, settings: Setting, state: SetGame<SetCard>.Card.CardState) {
            self.isSelected = isSelected
            self.settings = settings
            self.state = state
            rotation = isFaceUp ? 0 : 180
        }
        
        
        func body(content: Content) -> some View {
            ZStack {
                let base = RoundedRectangle(cornerRadius: cornerRadius)
                base.strokeBorder(.white, lineWidth: borderLineWidth)
                    .background(base.fill(state == .hint ? settings.colorHint : .white))
                    .overlay(content)
                    
                    .opacity(isFaceUp ? 1 : 0)
                base.fill(settings.deckColor)
                    .opacity(isFaceUp ? 0 : 1)
            }
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.linear, value: isSelected)
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
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
        private let borderLineWidth: CGFloat = 1
        private let downwardOffset: CGFloat = 200
    }

    extension View {
        func cardMod(isSelected: Bool, settings: Setting, isFaceUp: Bool,  state: SetGame<SetCard>.Card.CardState) -> some View {
            modifier(CardModifier(isFaceUp: isFaceUp, isSelected: isSelected, settings: settings, state: state))
        }
    }
