//
//  SetCardView.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import SwiftUI

struct SetCardView: View {
    
    var card: SetCard
    var colorsShape: [Color] = [.red, .green, .purple]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ForEach(0..<card.number.rawValue) { index in
                    cardShape().frame(height: geometry.size.height / 4)
                }
                Spacer()
            }
        }
        .padding(6)
        .foregroundStyle(colorsShape[card.color.rawValue - 1])
        .aspectRatio(CGFloat(2.0/3.0), contentMode: .fit)
    }
    
    private func cardShape() -> some View {
        ZStack {
            switch card.shape {
            case .v1:
                shapeFill(shape: Diamond())
            case .v2:
                shapeFill(shape: Capsule())
            case .v3:
                shapeFill(shape: Squiggle())
            }
        }
    }
    
    private func shapeFill<setShape>(shape: setShape) -> some View where setShape: Shape {
        ZStack {
            switch card.fill {
            case .v1:
                shape.stroke(lineWidth: lineWidth)
            case .v2:
                shape.fillPlusBorder(lineWidth)
            case .v3:
                shape.stripe(lineWidth)
            }
        }
    }
    
    private let lineWidth: CGFloat = 3
}

#Preview {
    SetCardView(card: SetCard(number: .v3, color: .v2, shape: .v1, fill: .v3))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        
        )
        .padding()
}
