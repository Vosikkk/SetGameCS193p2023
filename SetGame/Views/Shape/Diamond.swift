//
//  Diamond.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import SwiftUI


struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var p = Path()
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let rightSide = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        let leftSide = CGPoint(x: rect.minX, y: rect.midY)
        
        p.move(to: top)
        p.addLine(to: rightSide)
        p.addLine(to: bottom)
        p.addLine(to: leftSide)
        p.addLine(to: top)
        
        return p
    }
    
}

#Preview {
    VStack {
        Diamond().blur(5)
        Diamond().stripe(5)
        Diamond().fillPlusBorder(5)
    }
    .padding()
}
