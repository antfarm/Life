//
//  ContentView.swift
//  Life
//
//  Created by sean on 26.11.20.
//

import SwiftUI


struct ContentView: View {
    
    @State var viewModel: GameOfLifeViewModel
    
    
    var body: some View {
        
        ZStack() {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack() {

                GameOfLifeView()
                    .padding(5)

                HStack() {
                    Button("Run", .startButtonPressed, !viewModel.isAnimating)
                    Button("Stop", .stopButtonPressed, viewModel.isAnimating)
                    Button("Step", .stepButtonPressed, !viewModel.isAnimating)
                    Button("Random", .randomizeButtonPressed, !viewModel.isAnimating)
                    Button("Clear", .clearButtonPressed, !viewModel.isAnimating)
                }
                .padding(10)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .environment(viewModel)
    }
}


struct Button: View {

    @Environment(GameOfLifeViewModel.self) var viewModel
    
    private let text: String
    private let event: GameOfLifeViewModel.Event
    private let disabled: Bool
    
    init(_ text: String, _ event: GameOfLifeViewModel.Event, _ enabled: Bool = false) {
        self.text = text
        self.event = event
        self.disabled = !enabled
    }
    
    var body: some View {
    
        return SwiftUI.Button(action: {
            viewModel.handleEvent(event: event)
        }, label: {
            Text(text)
                .font(.system(size: 15))
                .fontWeight(disabled ? .regular : .bold)
                .foregroundColor(disabled ? .gray : .white)
        })
        .disabled(disabled)
        .frame(height: 36)
        .frame(maxWidth: .infinity)
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

        let viewModel = GameOfLifeViewModel(model: model)
        
        ContentView(viewModel: viewModel)
    }
}
