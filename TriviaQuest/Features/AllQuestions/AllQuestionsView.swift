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
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    var filteredQuestions: [Question] {
        viewModel.questions.filter { question in
            if searchText == "" {
                return question.text != ""
            } else {
                return question.text?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }

    }
    
    var body: some View {
        NavigationView {
            VStack {
            List {
                ForEach(0..<filteredQuestions.count, id: \.self) { question in
                    
                    NavigationLink(destination: QuestionView(number: Int(viewModel.questions[question].number) )) {
                        QuestionRow(text: viewModel.questions[question].text ?? "no question", category: "Category: \(viewModel.questions[question].category ?? "no category")", difficulty: "Difficulty: \( viewModel.questions[question].difficulty ?? "no difficulty")", answeredCorrectly: viewModel.questions[question].answeredCorrect, answeredIncorrectly: viewModel.questions[question].answeredWrong)
                    }
                }.listRowBackground(Color.clear)
            }.onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
            .listRowInsets(EdgeInsets())
                .task {
                    Task.init {
                        await viewModel.load15Questions(networkManager: NetworkManager(session: URLSession.shared))
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Today's Questions")
        }
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
                .background(.white)
                .cornerRadius(20)
                
            HStack {
                Text(category).foregroundColor(.blue)
                Text(difficulty).foregroundColor(.red)
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
        .padding(.vertical, 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AllQuestionsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
