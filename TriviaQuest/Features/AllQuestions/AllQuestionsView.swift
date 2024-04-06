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
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<viewModel.questions.count, id: \.self) { question in

                    NavigationLink(destination: QuestionView()) {
                        QuestionRow(text: viewModel.questions[question].text ?? "no question", category: "Category: \(viewModel.questions[question].category ?? "no category")", difficulty: "Difficulty: \( viewModel.questions[question].difficulty ?? "no difficulty")")
                    }
                }
            }.listRowInsets(EdgeInsets())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    //                    Button(action: addItem) {
                    //                        Label("Add Item", systemImage: "plus")
                    //                    }
                }
            }.task {
                viewModel.load15Questions(networkManager: NetworkManager(session: URLSession.shared))
            }
        }
    }
}

struct QuestionRow: View {
    
    var text: String
    var category: String
    var difficulty: String
    var body: some View {
        VStack {
            Text(text)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(20)
            HStack {
                Text(category).foregroundColor(.blue)
                Text(difficulty).foregroundColor(.red)
            }
        }
        .padding(.vertical, 5)
    }
}

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AllQuestionsView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
