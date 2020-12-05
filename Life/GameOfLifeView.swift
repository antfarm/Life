//
//  GameOfLifeView.swift
//  Life
//
//  Created by sean on 04.12.20.
//

import SwiftUI


struct CellView: View {
    
    var row: Int
    var column: Int
    
    @ObservedObject var game: GameOfLifeViewModel
    
    
    var body: some View {
        
        let state = game.grid[row][column]

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
                game.toggleCell(row: row, column: column)
            }
    }
}


struct GameOfLifeView: View {
    
    @ObservedObject var game: GameOfLifeViewModel
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            ForEach((0..<game.rows), id: \.self) { row in
                
                HStack(spacing: 0) {
                    ForEach((0..<game.columns), id: \.self) { column in
                                                        
                        CellView(row: row, column: column, game: game)
                    }
                }
            }
        }
    }
}
