//
//  GameOfLife.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Foundation


public enum CellState {
    
    case alive
    case dead
    
    var toggled: CellState {

        switch self {
        case .alive:
            return .dead
        case .dead:
            return .alive
        }
    }
    
    mutating func toggle() {
        self = self.toggled
    }
}


class GameOfLife {

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
                gridBuffer[row][column] = self.nextState(row: row, column: column)
            }
        }
        
        grid = gridBuffer
    }
    
    
    private func nextState(row: Int, column: Int) -> CellState {
        
        let cellState = grid[row][column]
        let numAlive = numNeighborsAlive(row: row, column: column)
        
        if cellState == .alive && [2, 3].contains(numAlive) {
            return .alive
        }
        
        if cellState == .dead && numAlive == 3 {
            return .alive
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
            grid[row][column] == .alive
        }
        
        print(aliveNeighbors.count)
        
        return aliveNeighbors.count
    }
}
