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

    private(set) var cells: [[GameOfLife.CellState]]

    private var model: GameOfLife
    private var cancellables = Set<AnyCancellable>()

    private var timer: AnyCancellable?
    private let updateInterval: TimeInterval = 0.2
    
    
    init(model: GameOfLife) {
        
        self.model = model

        cells = model.cells
        
        model.$cells
            .receive(on: RunLoop.main)
            .assign(to: \.cells, on: self)
            .store(in: &cancellables)
    }
    
    
    enum Event {
        
        case startButtonPressed
        case stopButtonPressed
        case stepButtonPressed
        case clearButtonPressed
        case randomizeButtonPressed
        case cellTapped(column: Int, row: Int)
    }
    
    
    private(set) var isAnimating = false {
        willSet {
            switch newValue {
            case true:
                startAnimation()
            case false:
                stopAnimation()
            }
        }
    }
    

    func handleEvent(event: Event) {
        
        switch event {
        case .startButtonPressed:
            isAnimating = true
        case .stopButtonPressed:
            isAnimating = false
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
    
    
    private func startAnimation() {
        
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.model.step()
            }
    }
    
    
    private func stopAnimation() {
        
        timer?.cancel()
        timer = nil
    }
}
