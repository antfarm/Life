//
//  GameOfLifeViewModel.swift
//  Life
//
//  Created by sean on 29.11.20.
//

import Combine
import Observation
import SwiftUI


@Observable
class GameOfLifeViewModel {
    
    var columns: Int { model.columns }
    var rows: Int { model.rows }

    var cells: [[GameOfLife.CellState]] { model.cells }

    private var model: GameOfLife

    private var timer: AnyCancellable?
    private let updateInterval: TimeInterval = 0.05
    
    
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
        
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.model.step()
            }
        
        isAnimating = true
    }
    
    
    private func stopAnimation() {
        
        timer?.cancel()
        timer = nil
        
        isAnimating = false
    }
}
