//
//  ContentView.swift
//  Life
//
//  Created by sean on 26.11.20.
//

import SwiftUI

struct CellView: View {

    var row: Int!
    var column: Int!

    @State var cellState = CellState.dead
        
    init(row: Int, column: Int, state: CellState = .dead) {
        self.cellState = state
        self.row = row
        self.column = column
    }
            
    var body: some View {
        Rectangle()
            .fill(cellState == .alive ? Color.red : .blue)
            .frame(width: 20, height: 20, alignment: .center)
            .onTapGesture() {
                cellState.toggle()
            }
    }
}


struct ContentView: View {
    
    @ObservedObject var game = GameOfLifeViewModel()
    
    var body: some View {
        VStack() {
            ForEach((0..<game.rows), id: \.self) { row in
                HStack() {
                    ForEach((0..<game.columns), id: \.self) { column in
                        
                        // CellView(row: row, column: column, state: game.grid[row][column])
                        Rectangle()
                            .fill(game.grid[row][column] == .alive ? Color.red : .white)
                            .frame(width: 12, height: 12, alignment: .center)
                            .onTapGesture() {
                                game.setCell(row: row, column: column, state: game.grid[row][column].toggled)
                            }
                    }
                }
                .padding(0)
            }
            
            HStack() {
                Button(action: {
                    game.start()
                }) {
                    Text("START")
                        .padding(40)
                }
                
                Button(action: {
                    game.stop()
                }) {
                    Text("STOP")
                        .padding(20)
                }

                Button(action: {
                    game.step()
                }) {
                    Text("STEP")
                        .padding(20)
                }
            }

            HStack() {
                Button(action: {
                    game.randomize()
                }) {
                    Text("RANDOM")
                        .padding(20)
                }
                
                Button(action: {
                    game.clear()
                }) {
                    Text("CLEAR")
                        .padding(20)
                }
            }

        }.padding(0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
