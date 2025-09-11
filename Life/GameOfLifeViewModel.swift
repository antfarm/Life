//
//  GameOfLifeViewModel.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Observation
import SwiftUI


@Observable
class GameOfLifeViewModel {
    
    var columns: Int { model.columns }
    var rows: Int { model.rows }

    var cells: [[GameOfLife.CellState]] { model.cells }

    private var model: GameOfLife

    private var loopTask: Task<Void, Never>?
    private let updateInterval: Duration = .milliseconds(50)
    
    
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
    
    
    func handleEvent(event: Event) {
        
        switch event {
        case .startButtonPressed:
            startAnimation()
        case .stopButtonPressed:
            stopAnimation()
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
    
    
    private(set) var isAnimating = false
    

    private func startAnimation() {
        
        loopTask = Task { @MainActor in
            while !Task.isCancelled && isAnimating {
                model.step()
                try? await Task.sleep(for: updateInterval)
            }
        }
        
        isAnimating = true
    }
    
    
    private func stopAnimation() {
        
        loopTask?.cancel()
        loopTask = nil
        
        isAnimating = false
    }
}
