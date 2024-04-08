//
//  WelcomeView.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var areYouSure = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("brain").resizable()
                        .frame(width: 125, height: 125)
                    Image("glasses").resizable()
                        .frame(width: 98, height: 98)
                }.padding(EdgeInsets(top: 100, leading: 0, bottom: 0, trailing: 0))
                Text("Trivia Quest").padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("Permanent Marker Regular", size: 48))
                Spacer()
                NavigationLink(destination: AllQuestionsView()) {
                    Text("Let's Play!")
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .font(Font.custom("Permanent Marker Regular", size: 20))
                        .foregroundColor(.white)
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.red)
                ).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                Button(action: {
                    areYouSure = true
                }){
                    Text("Refresh Questions").padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .font(Font.custom("Permanent Marker Regular", size: 20))
                        .foregroundColor(.white).background(
                            RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)).padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                .alert("Are you sure? Your current questions and answers will be deleted.", isPresented: $areYouSure) {
                    Button("New Questions please", role: nil) {
                        viewModel.deleteQuestions(coreDataService: PersistenceController.shared)
                    }
                    Button("Actually, no", role: .cancel) {}
                }
                NavigationLink(destination: HowItWorksView()) {
                    Text("How it Works")
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .font(Font.custom("Permanent Marker Regular", size: 20))
                        .foregroundColor(.white)
                }.background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.purple)
                ).padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            }.foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Image("subtle-prism")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                )
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
