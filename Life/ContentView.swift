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
            Color.black.ignoresSafeArea()
            
            VStack() {

                GameOfLifeView()
                    .padding(5)

                HStack() {
                    Button("play", .startButtonPressed, !viewModel.isRunning)
                    Button("stop", .stopButtonPressed, viewModel.isRunning)
                    Button("forward.frame", .stepButtonPressed, !viewModel.isRunning)
                    Button("dice", .randomizeButtonPressed, !viewModel.isRunning)
                    Button("clear", .clearButtonPressed, !viewModel.isRunning)
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
    
    private let systemName: String
    private let event: GameOfLifeViewModel.Event
    private let disabled: Bool
    
    
    init(_ systemName: String, _ event: GameOfLifeViewModel.Event, _ enabled: Bool = false) {
        self.systemName = systemName
        self.event = event
        self.disabled = !enabled
    }
    
    
    var body: some View {
    
        return SwiftUI.Button(action: {
            viewModel.handleEvent(event: event)
        }, label: {
            Image(systemName: "\(systemName)\(disabled ? "" : ".fill")")
                .font(.system(size: 24))
                .fontWeight(disabled ? .regular : .bold)
                .foregroundColor(disabled ? .gray : .white)
        })
        .disabled(disabled)
        .frame(height: 36)
        .frame(maxWidth: .infinity)
    }
}


#Preview {
       
    let model: GameOfLife = {
        let m = GameOfLife(columns: 50, rows: 80)
        m.randomizeCells()
        for _ in 0..<20 { m.step() }
        return m
    }()

    let viewModel = GameOfLifeViewModel(model: model)

    ContentView(viewModel: viewModel)
}
