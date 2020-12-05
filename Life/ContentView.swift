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
        
        ZStack() {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack() {

                GameOfLifeView(game: game)
                
                HStack() {
                    Button("RUN") { game.start() }
                    Button("STOP") { game.stop() }
                    Button("STEP") { game.step() }
                    Button("RAND") { game.randomize() }
                    Button("CLEAR") { game.clear() }
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
                .padding(5)
                .foregroundColor(Color.gray)
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
