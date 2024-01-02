//
//  StripedForm.swift
//  SetGame
//
//  Created by Саша Восколович on 03.01.2024.
//

import SwiftUI


struct StripedForm: Shape {
    
    var spacing: CGFloat = 3.5
    
    func path(in rect: CGRect) -> Path {
        
        let start = CGPoint(x: rect.minX, y: rect.minY)
        
        var p = Path()
        p.move(to: start)
        
        while p.currentPoint!.x < rect.maxX {
            p.addLine(to: CGPoint(x: p.currentPoint!.x, y: rect.maxY)) // up & down
            p.move(to: CGPoint(x: p.currentPoint!.x + spacing, y: rect.minY)) // down & up
        }
        
        return p
    }
}


#Preview {
    ZStack {
        StripedForm().stroke().clipShape(Diamond())
        Diamond().stroke(lineWidth: 2)
    }
    .padding()
}
