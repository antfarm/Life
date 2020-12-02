//
//  ContentView.swift
//  Life
//
//  Created by sean on 26.11.20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var game = GameOfLifeViewModel()
    
    
    var body: some View {
        // GameOfLifeView(game: $game)
        
        ZStack() {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack() {

                // GameOfLifeView(game: $game)
                
                VStack(spacing: 0) {
                    ForEach((0..<game.rows), id: \.self) { row in
                        
                        HStack(spacing: 0) {
                            ForEach((0..<game.columns), id: \.self) { column in
                                                                
                                let state = game.grid[row][column]

                                // CellView(row: row, column: column, state: game.grid[row][column])

                                switch state {
                                case .alive(age: let age):
                                    let opacity = Double(10 - min(age, 8)) / 10.0
                                    
                                    Circle()
                                        .fill(Color.yellow)
                                        .opacity(opacity)
                                        .onTapGesture() {
                                            game.setCell(row: row, column: column, state: game.grid[row][column].toggled)
                                        }

                                case .dead:
                                    Rectangle()
                                        .fill(Color.black)
                                        .onTapGesture() {
                                            game.setCell(row: row, column: column, state: state.toggled)
                                        }
                                }
                            }
                        }
                        .padding(0)
                    }
                }
                
                HStack() {
                    Button(action: {
                        game.start()
                    }) {
                        Text("RUN")
                            .padding(20)
                            .foregroundColor(Color.orange)
                    }
                    
                    Button(action: {
                        game.stop()
                    }) {
                        Text("STOP")
                            .padding(20)
                            .foregroundColor(Color.orange)
                    }

                    Button(action: {
                        game.step()
                    }) {
                        Text("STEP")
                            .padding(20)
                            .foregroundColor(Color.orange)
                    }
                }

                HStack() {
                    Button(action: {
                        game.randomize()
                    }) {
                        Text("RANDOM")
                            .padding(20)
                            .foregroundColor(Color.orange)
                    }
                    
                    Button(action: {
                        game.clear()
                    }) {
                        Text("CLEAR")
                            .padding(20)
                            .foregroundColor(Color.orange)
                    }
                }

            }.padding(0)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
