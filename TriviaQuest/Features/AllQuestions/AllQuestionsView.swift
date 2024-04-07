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
                    
                    NavigationLink(destination: QuestionView(number: Int(filteredQuestions[question].number) )) {
                        QuestionRow(text: filteredQuestions[question].text ?? "no question", category: "Category: \(filteredQuestions[question].category ?? "no category")", difficulty: "Difficulty: \( filteredQuestions[question].difficulty ?? "no difficulty")", answeredCorrectly: filteredQuestions[question].answeredCorrect, answeredIncorrectly: filteredQuestions[question].answeredWrong)
                    }.listRowSeparator(.hidden)
                }.listRowBackground(Color.clear)
            }
            .background(.blue)
                .task {
                    Task.init {
                        await viewModel.load15Questions(networkManager: NetworkManager(session: URLSession.shared))
                    }
                }
                .alert("There was an error loading the questions. Please check your network connection and restart the app.", isPresented: $viewModel.networkErrorAlert) {
                    Button("OK", role: .cancel) {}
                }
            }.background(            Rectangle()
                .fill(Color.blue)
                .edgesIgnoringSafeArea(.all))
            .searchable(text: $searchText)
            .navigationTitle("Today's Questions")
        }.background(Color.blue)
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
