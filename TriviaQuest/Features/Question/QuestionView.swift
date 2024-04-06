//
//  QuestionView.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import SwiftUI

struct QuestionView: View {
    
    @StateObject private var viewModel = QuestionViewModel()
    @State var number: Int
    
    var body: some View {
        VStack {
            if !viewModel.question.isEmpty {
                Text(viewModel.question[0].text ?? "no question")
                Text(viewModel.question[0].category ?? "no category")
                Text(viewModel.question[0].difficulty ?? "no difficulty")
                if !viewModel.answers.isEmpty {
                    ForEach (0..<viewModel.answers.count, id: \.self) { a in
                        Button(action: {
                            print("hello")
                        }) {
                            Text(viewModel.answers[a].text ?? "no answer text")
                        }
                    }
                } else {
                    Button(action: {
                        print("hello")
                    }) {
                        Text("true")
                    }
                    Button(action: {
                        print("hello")
                    }) {
                        Text("false")
                    }
                }
            }
        }.task {
            viewModel.getQuestion(number)
        }
    }
}

//struct QuestionView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionView(number: )
//    }
//}
