//
//  GameOfLifeViewModel.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import SwiftUI


@Observable
class GameOfLifeViewModel {
    
    var columns: Int { model.columns }
    var rows: Int { model.rows }

    var cells: [[GameOfLife.CellState]] { model.cells }

    private var model: GameOfLife

    private var loopTask: Task<Void, Never>?
    private let updateInterval: Duration = .milliseconds(50)
    
    private(set) var isRunning = false
    

    init(model: GameOfLife) {
        
        self.model = model
    }
    
    
    enum Event {
        
        case startButtonPressed
        case stopButtonPressed
        case stepButtonPressed
        case clearButtonPressed
        case randomizeButtonPressed
        case cellTapped(column: Int, row: Int)
    }
    
    
    @MainActor
    func handleEvent(event: Event) {
        
        switch event {
        case .startButtonPressed:
            start()
        case .stopButtonPressed:
            stop()
        case .stepButtonPressed:
            model.step()
        case .clearButtonPressed:
            model.clearCells()
        case .randomizeButtonPressed:
            model.randomizeCells()
        case .cellTapped(let column, let row):
            model.toggleCell(column: column, row: row)
        }
    }
    
    
    @MainActor
    private func start() {
        
        loopTask = Task {
            while !Task.isCancelled && isRunning {
                model.step()
                try? await Task.sleep(for: updateInterval)
            }
        }
        
        isRunning = true
    }
    
    
    @MainActor
    private func stop() {
        
        loopTask?.cancel()
        loopTask = nil
        
        isRunning = false
    }
}
