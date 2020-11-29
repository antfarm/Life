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
        self.cellState = cellState
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
    
    @ObservedObject var game = GameOfLife(rows: 10, columns: 10)
    
    var body: some View {
        VStack() {
            ForEach((1...game.rows), id: \.self) { row in
                HStack() {
                    ForEach((1...game.columns), id: \.self) { column in
                        CellView(row: row, column: column, state: .dead)
                            .padding(0)
                    }
                }
                .padding(0)
            }
            
            Button(action: {
                game.start()
            }) {
                Text("GO")
                    .padding(40)
            }
        }.padding(0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
