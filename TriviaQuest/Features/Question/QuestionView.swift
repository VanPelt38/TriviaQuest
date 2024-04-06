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
    @State private var answerChosen: Bool?
    @State private var answerNumberChosen: Int?
    
    var body: some View {
        VStack {
            if !viewModel.question.isEmpty {
                Text(viewModel.question[0].text ?? "no question")
                Text(viewModel.question[0].category ?? "no category")
                Text(viewModel.question[0].difficulty ?? "no difficulty")
                if !viewModel.answers.isEmpty {
                    ForEach (0..<viewModel.answers.count, id: \.self) { a in
                        Button(action: {
                            answerChosen = viewModel.answers[a].correct ? true : false
                            answerNumberChosen = Int(viewModel.answers[a].number)
                        }) {
                            HStack {
                                Text(viewModel.answers[a].text ?? "no answer text").foregroundColor(.white)
                                if answerChosen != nil {
                                    if viewModel.answers[a].correct {
                                        Image("green-tick")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    } else if viewModel.answers[a].number == answerNumberChosen! {
                                        Image("red-cross")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        }
                        .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(setAnswerColour(answerNo: a))
                                )
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
                if let answer = answerChosen {
                    setAnswerMessage(answer)
                }
            }
        }.task {
            viewModel.getQuestion(number)
        }
    }
    
    func setAnswerMessage(_ answer: Bool) -> Text {
        return answer ? Text("Nice Going!").foregroundColor(Color.green) : Text("Better Luck Next Time...").foregroundColor(Color.red)
    }
    
    func setAnswerColour(answerNo: Int) -> Color {
        
        switch answerNo {
        case 0:
            return .blue
        case 1:
            return .purple
        case 2:
            return .yellow
        case 3:
            return .mint
        default:
            return .blue
        }
    }
}

//struct QuestionView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionView(number: )
//    }
//}
