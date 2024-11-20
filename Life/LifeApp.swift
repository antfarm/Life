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
        
        let model: GameOfLife = {
            let m = GameOfLife(columns: 50, rows: 80)
            m.randomizeCells()
            for _ in 0..<20 { m.step() }
            return m
        }()

        let viewModel = GameOfLifeViewModel(model: model)

        WindowGroup {
            ContentView(viewModel: viewModel)
                .statusBar(hidden: true)
        }
    }
}
