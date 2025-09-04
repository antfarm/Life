//
//  GameOfLife.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Foundation


class GameOfLife: ObservableObject {

    enum CellType {
        
        case a
        case b
        
        static func random() -> Self {
            Int.random(in: 0...1) == 0 ? .a : .b
        }
    }

    
    enum CellState {
        
        case alive(age: Int, type: CellType)
        case dead
        
        static func random(percentAlive: Int) -> Self {
            Int.random(in: 0..<100) < percentAlive
                ? .alive(age: 0, type: CellType.random())
                : .dead
        }
        
        func toggled() -> Self {
            switch self {
            case .alive(_, _):
                return .dead
            case .dead:
                return .alive(age: 0, type: CellType.random())
            }
        }

    }

    
    let columns: Int
    let rows: Int

    @Published private(set) var cells: [[CellState]]
    
    
    init(columns: Int, rows: Int) {
        
        self.columns = columns
        self.rows = rows
        
        cells = Array(repeating: Array(repeating: .dead, count: rows), count: columns)
    }
    
    
    func step() {
        
        applyToAllCells { column, row in
            nextState(column: column, row: row)
        }
    }
    
    
    func clearCells() {
        
        applyToAllCells { _, _ in
            .dead
        }
    }
    
    
    func randomizeCells() {

        applyToAllCells { _, _ in
            CellState.random(percentAlive: 25)
        }
    }
    
    
    func toggleCell(column: Int, row: Int) {
        
        cells[column][row] = cells[column][row].toggled()
    }
    
    
    private func nextState(column: Int, row: Int) -> CellState {
        
        let (typeACount, typeBCount) = countNeighbors(column: column, row: row)
        let aliveCount = typeACount + typeBCount

        switch cells[column][row] {
        case .alive(age: let age, type: let type):
            if [2, 3].contains(aliveCount) {
                return .alive(age: age + 1, type: type)
            }
        case .dead:
            if aliveCount == 3 {
                return .alive(age: 0, type: typeBCount > typeACount ? .b : .a )
            }
        }
        
        return .dead
    }
    
    
    private func countNeighbors(column: Int, row: Int) -> (Int, Int) {

        let neighbors = neighborCells(column: column, row: row)
        
        let neighborsAlive = neighbors.filter {
            if case .alive = $0 { return true } else { return false }
        }
        
        let neighborsTypeA = neighborsAlive.filter {
            if case .alive(_, .a) = $0 { return true } else { return false }
        }
        
        let typeACount = neighborsTypeA.count
        let typeBCount = neighborsAlive.count - typeACount
        
        return (typeACount, typeBCount)
    }
    
    
    private func neighborCells(column: Int, row: Int) -> [CellState] {
        
        let neighborhood: [(Int, Int)] = [(-1, -1), (0, -1), (1, -1),
                                          (-1,  0),          (1,  0),
                                          (-1,  1), (0,  1), (1,  1)]
        
        let neighbors = neighborhood.map {
            cells[(column + $0 + columns) % columns][(row + $1 + rows) % rows]
        }
        
        return neighbors
    }
        
    
    private func applyToAllCells(_ newState: (Int, Int) -> CellState) {
        
        var cellsBuffer: [[CellState]] = Array(repeating: Array(repeating: .dead, count: rows), count: columns)
        
        for column in 0..<columns {
            for row in 0..<rows {
                cellsBuffer[column][row] = newState(column, row)
            }
        }
        
        cells = cellsBuffer
    }


    func printCells() {
        
        for column in 0..<columns {
            for row in 0..<rows {
                switch cells[column][row] {
                case .alive(_, .a):
                    print("A", terminator: "")
                case .alive(_, .b):
                    print("B", terminator: "")
                case .dead:
                    print(".", terminator: "")
                }
            }
            
            print()
        }
    }
}
