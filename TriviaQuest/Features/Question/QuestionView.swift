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
        ZStack {
           
        VStack {
            if !viewModel.question.isEmpty {
                Text(viewModel.question[0].text ?? "no question").fontWeight(.bold).padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)).font(Font.custom("New", size: 30))
                Text("Category: \(viewModel.question[0].category ?? "no category")").font(.footnote).italic().foregroundColor(.blue)
                Text("Difficulty: \(viewModel.question[0].difficulty ?? "no difficulty")").font(.footnote).italic().foregroundColor(.red)
                Spacer()
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
                            viewModel.saveData(coreDataService: PersistenceController.shared)
                        }) {
                            HStack {
                                Text(viewModel.answers[a].text ?? "no answer text").foregroundColor(.white).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
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
                                viewModel.saveData(coreDataService: PersistenceController.shared)                            }
                        }
                    }) {
                        HStack{
                            Text("true").foregroundColor(.white).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
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
                                viewModel.saveData(coreDataService: PersistenceController.shared)
                            }
                        }
                    }) {
                        HStack{
                            Text("false").foregroundColor(.white).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
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
                Spacer()
                if let answer = answerChosen {
                    setAnswerMessage(answer)
                }
                Spacer()
            }
        }.background(
            RoundedRectangle(cornerRadius: 10).fill(.white).padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        )
        .task {
            viewModel.getQuestion(number, coreDataService: PersistenceController.shared)
                if viewModel.question[0].answeredCorrect {
                    answerChosen = true
                } else if viewModel.question[0].answeredWrong {
                    answerChosen = false
                }
            }
            .disabled(answerChosen != nil)
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("subtle-prism")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            )
    }
    
    func setAnswerMessage(_ answer: Bool) -> Text {
        return answer ? Text("Nice Going!").foregroundColor(Color.green).bold() : Text("Better Luck Next Time...").foregroundColor(Color.red).bold()
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
