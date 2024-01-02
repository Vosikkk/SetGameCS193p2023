//
//  Extension+Shape.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import SwiftUI


extension Shape {
    
    func stripe(_ lineWidth: CGFloat = 2) -> some View {
        ZStack {
            StripedForm().stroke().clipShape(self)
            self.stroke(lineWidth: lineWidth)
        }
    }
    
    func blur(_ lineWidth: CGFloat = 2) -> some View {
        ZStack {
            self.fill().opacity(0.25)
            self.stroke(lineWidth: lineWidth)
        }
    }
    
    func fillPlusBorder(_ lineWdth: CGFloat = 2) -> some View {
        ZStack {
            self.fill()
            self.stroke(lineWidth: lineWdth)
        }
    }
}
