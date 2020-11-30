//
//  GameOfLifeViewModel.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Foundation
import SwiftUI
import Combine

class GameOfLifeViewModel: ObservableObject {
    
    let rows = 16
    let columns = 16
    
    private var looper: Util.Looper!

    private var game: GameOfLife!
    
    @Published var grid: [[CellState]]!
    
    
    init() {
        game = GameOfLife(rows: rows, columns: columns)
        
        randomize()
        
        looper = Util.Looper(loopTimeMillis: 200) {
        
            self.game.step()
            self.grid = self.game.grid

        }
    }
    
    func setCell(row: Int, column: Int, state: CellState) {
        
        game[row, column] = state
        
        grid = game.grid
    }
    
    
    func setGrid(_ grid: [[CellState]]) {
        
        for row in 0..<rows {
            for column in 0..<columns {
                self.game[row, column] = grid[row][column]
            }
        }

        self.grid = game.grid
    }
    
    
    func step() {
        game.step()
        grid = game.grid
    }

    
    func clear() {
        setGrid(emptyGrid())
    }
    
    
    func randomize() {
        setGrid(randomGrid())
    }
    
    
    func start() {
        looper.resume()
    }
    
    
    func stop() {
        looper.pause()
    }
    
    
    
    private func emptyGrid() -> [[CellState]] {
        
        return Array(repeating: Array(repeating: .dead, count: columns), count: rows)
    }
    
    
    private func randomGrid() -> [[CellState]] {
        
        var grid = emptyGrid()
        
        for row in 0..<rows {
            for column in 0..<columns {
                grid[row][column] = Int.random(in: 0...1) > 0 ? .alive : .dead
            }
        }

        return grid
    }
}
