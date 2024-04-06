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
