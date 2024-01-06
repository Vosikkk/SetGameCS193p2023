//
//  SetGameApp.swift
//  SetGame
//
//  Created by Саша Восколович on 02.01.2024.
//

import SwiftUI

@main
struct SetGameApp: App {
    @StateObject var game = SetCardGame()
    
    var body: some Scene {
        WindowGroup {
            SetCardGameView(setGame: game)
        }
    }
}
