//
//  LifeApp.swift
//  Life
//
//  Created by sean on 26.11.20.
//

import SwiftUI

@main
struct LifeApp: App {
    
    var body: some Scene {
        
        let model = GameOfLife(columns: 50, rows: 80)
        let game = GameOfLifeViewModel(model: model)

        WindowGroup {
            ContentView(game: game)
                .statusBar(hidden: true)
        }
    }
}
