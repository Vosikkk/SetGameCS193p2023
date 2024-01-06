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
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                   .stroke(Color.green, lineWidth: 3)
            )
    }
}

extension View {
    func greenButton() -> some View {
        modifier(ButtonModifier())
    }
}
