//
//  ContentView.swift
//  Life
//
//  Created by sean on 26.11.20.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var game: GameOfLifeViewModel
    
    
    var body: some View {
        
        ZStack() {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack() {

                GameOfLifeView()
                    .padding(5)

                HStack() {
                    Button("Run", .startButtonPressed)
                    Button("Stop", .stopButtonPressed)
                    Button("Step", .stepButtonPressed)
                    Button("Random", .randomizeButtonPressed)
                    Button("Clear", .clearButtonPressed)
                }
                .padding(10)
            }
        }
        .environmentObject(game)
    }
}


struct Button: View {

    @EnvironmentObject var game: GameOfLifeViewModel
    
    private let text: String
    private let event: GameOfLifeViewModel.Event
    
    init(_ text: String, _ event: GameOfLifeViewModel.Event) {
        self.text = text
        self.event = event
    }
    
    var body: some View {
    
        return SwiftUI.Button(action: {
            game.handleEvent(event: event)
        }, label: {
            Text(text)
                .bold()
                .padding(10)
                .foregroundColor(Color.gray)
        })
    }
}


struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
       
        let model: GameOfLife = {
            let m = GameOfLife(columns: 50, rows: 80)
            m.randomizeCells()
            for _ in 0..<20 { m.step() }
            return m
        }()

        let game = GameOfLifeViewModel(model: model)
        
        ContentView(game: game)
    }
}
