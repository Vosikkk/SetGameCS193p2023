//
//  ButtonModifier.swift
//  SetGame
//
//  Created by Саша Восколович on 05.01.2024.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(Constants.inset)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(.blue, lineWidth: Constants.lineWidth)
            )
    }
    
    struct Constants {
        static let inset: CGFloat = 8
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func greenButton() -> some View {
        modifier(ButtonModifier())
    }
}
