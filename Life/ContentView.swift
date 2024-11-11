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
                    Button("Run") { game.start() }
                    Button("Stop") { game.stop() }
                    Button("Step") { game.step() }
                    Button("Random") { game.randomize() }
                    Button("Clear") { game.clear() }
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
            let game = GameOfLifeViewModel()
            game.randomize()
            for _ in 0..<30 {
                game.step()
            }
            return game
        }()

        ContentView(game: game)
    }
}
