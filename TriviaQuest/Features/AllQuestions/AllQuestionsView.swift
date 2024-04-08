//
//  ContentView.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import SwiftUI
import CoreData

struct AllQuestionsView: View {
    
    @StateObject private var viewModel = AllQuestionsViewModel()
    @State private var searchText = ""
    @State private var selectedDifficulty: DifficultyFilter = .all
    var filteredQuestions: [Question] {
        switch selectedDifficulty {
        case .all:
            return viewModel.questions.filter { question in
                searchFilter(with: question, and: searchText)
            }
        case .easy:
            let easyQuestions = viewModel.questions.filter { $0.difficulty == "easy" }
            return easyQuestions.filter { question in
                searchFilter(with: question, and: searchText)            }
        case .medium:
            let mediumQuestions = viewModel.questions.filter { $0.difficulty == "medium" }
            return mediumQuestions.filter { question in
                searchFilter(with: question, and: searchText)            }
        case .hard:
            let hardQuestions = viewModel.questions.filter { $0.difficulty == "hard" }
            return hardQuestions.filter { question in
                searchFilter(with: question, and: searchText)            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Difficulty", selection: $selectedDifficulty) {
                    ForEach(DifficultyFilter.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue)
                    }
                }.pickerStyle(.segmented).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                List {
                    ForEach(0..<filteredQuestions.count, id: \.self) { question in
                        
                        NavigationLink(destination: QuestionView(number: Int(filteredQuestions[question].number) )) {
                            QuestionRow(text: filteredQuestions[question].text ?? "no question", category: "Category: \(filteredQuestions[question].category ?? "no category")", difficulty: "Difficulty: \( filteredQuestions[question].difficulty ?? "no difficulty")", answeredCorrectly: filteredQuestions[question].answeredCorrect, answeredIncorrectly: filteredQuestions[question].answeredWrong)
                        }.listRowSeparator(.hidden)
                    }.listRowBackground(Color.clear)
                }.task {
                    Task.init {
                        await viewModel.load15Questions(networkManager: NetworkManager(session: URLSession.shared), coreDataService: PersistenceController.shared)
                    }
                }
                .alert("There was an error loading the questions. Please check your network connection and restart the app.", isPresented: $viewModel.networkErrorAlert) {
                    Button("OK", role: .cancel) {}
                }
            }.searchable(text: $searchText)
                .navigationTitle("Today's Questions")
        }
    }
    
    func searchFilter(with question: Question, and text: String) -> Bool {
        
        if text == "" {
            return question.text != ""
        } else {
            return question.text?.lowercased().contains(text.lowercased()) ?? false
        }
    }
    
    enum DifficultyFilter: String, CaseIterable {
        
        case all = "All"
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct QuestionRow: View {
    
    var text: String
    var category: String
    var difficulty: String
    var answeredCorrectly: Bool
    var answeredIncorrectly: Bool
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(.black)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            HStack {
                Text(category).foregroundColor(.blue).font(.footnote).italic()
                Text(difficulty).foregroundColor(.red).font(.footnote).italic()
                if answeredCorrectly {
                    Image("green-tick")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                if answeredIncorrectly {
                    Image("red-cross")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(.white)
        .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AllQuestionsView()
    }
}
