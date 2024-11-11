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
    
    let rows = 80
    let columns = 50
    
    let generationMillis = 100
    
    private var looper: Util.Looper!
    private var game: GameOfLife!
    
    @Published var cells: [[GameOfLife.CellState]]!
    
    
    init() {
        game = GameOfLife(rows: rows, columns: columns)
        cells = game.cells

        looper = Util.Looper(loopTimeMillis: generationMillis) {
            self.step()
        }
    }

    
    func start() {
        looper.resume()
    }
    
    
    func stop() {
        looper.pause()
    }
    
    
    func step() {
        game.step()
        cells = game.cells
    }

    
    func toggleCell(row: Int, column: Int) {
        setCell(row: row, column: column, state: game[row, column].toggled)
    }

    
    func clear() {
        setGrid(emptyGrid())
    }
    
    
    func randomize() {
        setGrid(randomGrid())
    }
    
    
    private func setCell(row: Int, column: Int, state: GameOfLife.CellState) {
        game[row, column] = state
        cells = game.cells
    }
    
    
    private func setGrid(_ grid: [[GameOfLife.CellState]]) {
        
        for row in 0..<rows {
            for column in 0..<columns {
                game[row, column] = grid[row][column]
            }
        }
        
        self.cells = game.cells
    }
    

    private func emptyGrid() -> [[GameOfLife.CellState]] {
        return Array(repeating: Array(repeating: .dead, count: columns), count: rows)
    }
    
    
    private func randomGrid() -> [[GameOfLife.CellState]] {
        
        var grid = emptyGrid()
        
        for row in 0..<rows {
            for column in 0..<columns {
                grid[row][column] = Int.random(in: 0...2) == 0 ? .alive(age: 0) : .dead
            }
        }

        return grid
    }
}
