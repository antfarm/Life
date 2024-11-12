//
//  GameOfLifeView.swift
//  Life
//
//  Created by sean on 04.12.20.
//

import SwiftUI


struct GameOfLifeView: View {
    
    @EnvironmentObject var game: GameOfLifeViewModel
    
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach((0..<game.columns), id: \.self) { column in
                
                VStack(spacing: 0) {
                    ForEach((0..<game.rows), id: \.self) { row in
                        
                        CellView(state: game.cells[column][row]) {
                            game.handleEvent(event: .cellTapped(column: column, row: row))
                        }
                    }
                }
            }
        }
    }
}


struct CellView: View {
    
    let state: GameOfLife.CellState
    let onTap: () -> Void
    
    
    var body: some View {
        
        let opacity: Double = {
            switch state {
            case .alive(age: let age):
                return Double(10 - min(age, 6)) / 10.0
            case .dead:
                return 1
            }
        }()
        
        let color: Color = {
            switch state {
            case .alive:
                return .yellow
            case .dead:
                return .black
            }
        }()
        
        Circle()
            .fill(color)
            .opacity(opacity)
            .onTapGesture() {
                onTap()
            }
    }
}
