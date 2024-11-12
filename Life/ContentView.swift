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

                GameOfLifeView(game: game)
                
                HStack() {
                    Button("Run") { game.handleEvent(event: .startButtonPressed) }
                    Button("Stop") { game.handleEvent(event: .stopButtonPressed) }
                    Button("Step") { game.handleEvent(event: .stepButtonPressed) }
                    Button("Random") { game.handleEvent(event: .randomizeButtonPressed) }
                    Button("Clear") { game.handleEvent(event: .clearButtonPressed) }
                }
                .padding(10)
            }
        }
    }
}


struct Button: View {

    private let text: String
    private let action: () -> ()
    
    init(_ text: String, action: @escaping () -> ()) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
    
        return SwiftUI.Button(action: {
            action()
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
       
        let game: GameOfLifeViewModel = {
            
            let game = GameOfLifeViewModel(model: GameOfLife(columns: 50, rows: 80))
       
            game.handleEvent(event: .randomizeButtonPressed)
            
            for _ in 0..<30 {
                game.handleEvent(event: .stepButtonPressed)
            }
            return game
        }()

        ContentView(game: game)
    }
}
