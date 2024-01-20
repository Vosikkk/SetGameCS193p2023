//
//  FlyingText.swift
//  SetGame
//
//  Created by Саша Восколович on 20.01.2024.
//

import SwiftUI


struct FlyingText: View {
    
    let string = "Set🔥"
    let text: String
    let isAnimationEnabled: Bool
    @State private var offset: CGFloat = 0
    
    init(_ text: String, isAnimationEnabled: Bool) {
        self.text = text
        self.isAnimationEnabled = isAnimationEnabled
    }
    
    var body: some View {
        if isAnimationEnabled {
            Text(text)
                .font(.system(size: Constants.labelFontSize))
                .foregroundStyle(text == string ? .orange : .red)
                .shadow(color: .black, radius: Constants.shadowRadius, x: Constants.positionX, y: Constants.positionY)
                .offset(x: 0, y: offset)
            
                .opacity(offset != 0 ? 0 : 1)
                .onAppear {
                    withAnimation(.easeInOut(duration: Constants.Animation.duration)) {
                        offset = text == string ? Constants.Offset.moveUp : Constants.Offset.moveDown
                    }
                }
                .onDisappear {
                    offset = 0
                }
                .scaleEffect(Constants.Animation.scale)
        }
    }
    
    
    private struct Constants {
        static let shadowRadius: CGFloat = 1.5
        static let positionX: CGFloat = 1
        static let positionY: CGFloat = 1
        static let labelFontSize: CGFloat = 30
        
        struct Offset {
            static let moveUp: CGFloat = -200
            static let moveDown: CGFloat = 200
        }
        struct Animation {
            static let duration: CGFloat = 1.6
            static let scale: CGFloat = 3.0
        }
    }
}
