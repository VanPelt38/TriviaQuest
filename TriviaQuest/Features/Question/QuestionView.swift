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
                if !viewModel.answers.isEmpty && viewModel.answers.count > 2 {
                    ForEach (0..<viewModel.answers.count, id: \.self) { a in
                        Button(action: {
                            answerChosen = viewModel.answers[a].correct ? true : false
                            switch answerChosen {
                            case true:
                                viewModel.question[0].answeredCorrect = true
                            case false:
                                viewModel.question[0].answeredWrong = true
                            default:
                                viewModel.question[0].answeredCorrect = true
                            }
                            viewModel.question[0].incorrectAnswerChosen = viewModel.answers[a].number
                            viewModel.saveData()
                        }) {
                            HStack {
                                Text(viewModel.answers[a].text ?? "no answer text").foregroundColor(.white)
                                if answerChosen != nil {
                                    if viewModel.answers[a].correct {
                                        Image("green-tick")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    } else if viewModel.answers[a].number == viewModel.question[0].incorrectAnswerChosen {
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
                } else if !viewModel.answers.isEmpty {
                    Button(action: {
                        for a in viewModel.answers {
                            if a.number == 1 {
                                answerChosen = a.correct ? true : false
                                switch answerChosen {
                                case true:
                                    viewModel.question[0].answeredCorrect = true
                                case false:
                                    viewModel.question[0].answeredWrong = true
                                default:
                                    viewModel.question[0].answeredCorrect = true
                                }
                                viewModel.saveData()
                            }
                        }
                    }) {
                        HStack{
                            Text("true").foregroundColor(.white)
                            if let a = answerChosen {
                                if a {
                                    Image("green-tick")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image("red-cross")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }.background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(setAnswerColour(answerNo: 0))
                        )
                    Button(action: {
                        for a in viewModel.answers {
                            if a.number == 2 {
                                answerChosen = a.correct ? true : false
                                switch answerChosen {
                                case true:
                                    viewModel.question[0].answeredCorrect = true
                                case false:
                                    viewModel.question[0].answeredWrong = true
                                default:
                                    viewModel.question[0].answeredCorrect = true
                                }
                                viewModel.saveData()
                            }
                        }
                    }) {
                        HStack{
                            Text("false").foregroundColor(.white)
                            if let a = answerChosen {
                                if !a {
                                    Image("green-tick")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image("red-cross")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    }.background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(setAnswerColour(answerNo: 1))
                        )
                }
                if let answer = answerChosen {
                    setAnswerMessage(answer)
                }
            }
        }.task {
            viewModel.getQuestion(number)
            if viewModel.question[0].answeredCorrect {
                answerChosen = true
            } else if viewModel.question[0].answeredWrong {
                answerChosen = false
            }
        }
        .disabled(answerChosen != nil)
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
