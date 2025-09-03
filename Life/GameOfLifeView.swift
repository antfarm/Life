//
//  GameOfLifeView.swift
//  Life
//
//  Created by sean on 04.12.20.
//

import SwiftUI


struct GameOfLifeView: View {
    
    @Environment(GameOfLifeViewModel.self) var viewModel
    
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let cellSize = CGSize(width: geometry.size.width / CGFloat(viewModel.columns),
                                  height: geometry.size.height / CGFloat(viewModel.rows))
            
            Canvas { context, size in
                
                for column in 0..<viewModel.columns {
                    for row in 0..<viewModel.rows {
                        
                        let state = viewModel.cells[column][row]
                        
                        guard case .alive(let age) = state else { continue }
                            
                        let rect = CGRect(x: CGFloat(column) * cellSize.width,
                                          y: CGFloat(row) * cellSize.height,
                                          width: cellSize.width,
                                          height: cellSize.height)
                        
                        let opacity = Double(10 - min(age, 6)) / 10.0
                        let color = Color.yellow.opacity(opacity)
                        
                        context.fill(Path(ellipseIn: rect), with: .color(color))
                    }
                }
            }
            .onTapGesture { location in

                let column = Int(location.x / cellSize.width)
                let row = Int(location.y / cellSize.height)
                
                guard (0..<viewModel.columns).contains(column) && (0..<viewModel.rows).contains(row) else { return }
                    
                viewModel.handleEvent(event: .cellTapped(column: column, row: row))
            }
        }
    }
}
