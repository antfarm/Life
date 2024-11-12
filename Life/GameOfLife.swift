//
//  GameOfLife.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Foundation


class GameOfLife: ObservableObject {

    enum CellState {
        case alive(age: Int)
        case dead
    }

    let columns: Int!
    let rows: Int!

    @Published var cells: [[CellState]]!
    
    private var cellsBuffer: [[CellState]]!

    
    init(columns: Int, rows: Int) {
        
        self.columns = columns
        self.rows = rows
        
        func emptyGrid() -> [[CellState]] {
            Array(repeating: Array(repeating: .dead, count: rows), count: columns)
        }

        cells = emptyGrid()
        cellsBuffer = emptyGrid()
    }
    
    
    func step() {
        
        func nextState(column: Int, row: Int) -> CellState {
            
            let cellState = cells[column][row]
            let numAlive = numNeighborsAlive(column: column, row: row)
            
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
        
        for column in 0..<columns {
            for row in 0..<rows {
                cellsBuffer[column][row] = nextState(column: column, row: row)
            }
        }
        
        cells = cellsBuffer
    }
    
    
    private func numNeighborsAlive(column: Int, row: Int) -> Int {
        
        let neighborhood: [(Int, Int)] = [(-1, -1), (0, -1), (1, -1),
                                          (-1,  0),          (1,  0),
                                          (-1,  1), (0,  1), (1,  1)]
        
        let neighbors: [CellState] = neighborhood.map {
            cells[(column + $0 + columns) % columns][(row + $1 + rows) % rows]
        }
        
        let neighborsAlive = neighbors.filter { neighbor in
            switch neighbor {
            case .alive:
                return true
            case .dead:
                return false
            }
        }
        
        return neighborsAlive.count
    }
    
    
    func clearCells() {
        
        for column in 0..<columns {
            for row in 0..<rows {
                cells[column][row] = .dead
            }
        }
    }
    
    
    func randomizeCells() {

        for column in 0..<columns {
            for row in 0..<rows {
                cells[column][row] = Int.random(in: 0...4) == 0 ? .alive(age: 0) : .dead
            }
        }
    }
    
    
    func toggleCell(column: Int, row: Int) {
        
        cells[column][row] = cells[column][row].toggled
    }
    
    
    func printCells() {
        
        for column in 0..<columns {
            for row in 0..<rows {
                switch cells[column][row] {
                    case .alive(let age):
                        print(age, terminator: "")
                    case .dead:
                        print(".", terminator: "")
                }
            }
            
            print()
        }
    }
}


extension GameOfLife.CellState {
    
    var toggled: Self {
        switch self {
        case .alive(age: _):
            return .dead
        case .dead:
            return .alive(age: 0)
        }
    }
}
