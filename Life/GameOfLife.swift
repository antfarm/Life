//
//  GameOfLife.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Foundation


class GameOfLife {

    enum CellState {
        
        case alive(age: Int)
        case dead
        
        var toggled: CellState {
            switch self {
            case .alive(age: _):
                return .dead
            case .dead:
                return .alive(age: 0)
            }
        }
    }

    let rows: Int!, columns: Int!
    
    private(set) var grid: [[CellState]]!
    private var gridBuffer: [[CellState]]!
            
    subscript(row: Int, column: Int) -> CellState {
        get { return grid[row][column] }
        set { grid[row][column] = newValue }
    }

    
    init(rows: Int, columns: Int) {
        
        self.rows = rows
        self.columns = columns

        grid = Array(repeating: Array(repeating: .dead, count: columns), count: rows)
        gridBuffer = Array(repeating: Array(repeating: .dead, count: columns), count: rows)
    }
    
    
    func step() {
        
        for row in 0..<rows {
            for column in 0..<columns {
                gridBuffer[row][column] = nextState(row: row, column: column)
            }
        }
        
        grid = gridBuffer
    }
    
    
    private func nextState(row: Int, column: Int) -> CellState {
        
        let cellState = grid[row][column]
        let numAlive = numNeighborsAlive(row: row, column: column)
        
        switch cellState {
        case .alive(age: let age):
            
            if [2, 3].contains(numAlive) {
                return .alive(age: age + 1)
            }
        case .dead:
            
            if numAlive == 3 {
                return .alive(age: 0)
            }
        }
        
        return .dead
    }
    
    
    private func numNeighborsAlive(row: Int, column: Int) -> Int {
        
        struct Neighborhood {
            static let neighbors: [(Int, Int)] = [(-1, -1), (0, -1), (1, -1),
                                                  (-1,  0),          (1,  0),
                                                  (-1,  1), (0,  1), (1,  1)]
        }
        
        let neighbors: [(Int, Int)] = Neighborhood.neighbors.map { (rowOffset, columnOffset) in
            let r = (rows + row + rowOffset) % rows
            let c = (columns + column + columnOffset) % columns
            return (r, c)
        }
        
        let aliveNeighbors = neighbors.filter { (row, column) in
            switch grid[row][column] {
            case .alive(age: _): return true
            case .dead: return false
            }
        }
        
        return aliveNeighbors.count
    }
}
