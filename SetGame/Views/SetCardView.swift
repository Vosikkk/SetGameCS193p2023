//
//  SetCardView.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import SwiftUI

struct SetCardView: View {
    
    var card: SetCard
    var settings: Setting
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ForEach(0..<card.number.rawValue, id: \.self) { index in
                    cardShape().frame(height: card.number.rawValue < 3 ? geometry.size.height / 4.0 : (geometry.size.height - Constants.offset) / CGFloat(card.number.rawValue))
                }
                Spacer()
            }
        }
        .padding(Constants.inset)
        .foregroundStyle(settings.colorsShape[card.color.rawValue - 1])
        .aspectRatio(Constants.aspectRatio, contentMode: .fit)
    }
    
    @ViewBuilder private func cardShape() -> some View {
        switch shapeInSet(card: card) {
        case .diamond: shapeFill(shape: Diamond())
        case .oval: shapeFill(shape: Capsule())
        case .squiggle: shapeFill(shape: Squiggle())
        }
    }
    
    @ViewBuilder private func shapeFill<setShape>(shape: setShape) -> some View where setShape: Shape {
        switch fillInSet(card: card) {
        case .stroke: shape.stroke(lineWidth: Constants.lineWidth)
        case .fill:   shape.fillPlusBorder()
        case .stripe: shape.stripe()
        }
    }
    
    private func shapeInSet(card: SetCard) -> Setting.ShapesInSet {
        settings.shapes[card.shape.rawValue - 1]
    }
    
    private func fillInSet(card: SetCard) -> Setting.FillInSet {
        settings.fillForShapes[card.fill.rawValue - 1]
    }
    
    private struct Constants {
        static let lineWidth: CGFloat = 3
        static let aspectRatio: CGFloat = 2/3
        static let offset: CGFloat = 32
        static let inset: CGFloat = 6
    }
}

#Preview {
    SetCardView(card: SetCard(number: .v3, color: .v3, shape: .v2, fill: .v3), settings: Setting())
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        
        )
        .padding()
}
