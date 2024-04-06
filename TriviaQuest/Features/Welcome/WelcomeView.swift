//
//  WelcomeView.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 06/04/2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("brain")
                Text("Trivia Quest").padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("New", size: 48))
                NavigationLink(destination: AllQuestionsView()) {
                    Text("Let's Play!").padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                        .font(Font.custom("New", size: 20))

                }
//                NavigationLink(destination: MyIssues()) {
//                    Text("My Issues").padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
//                        .font(Font.custom("New", size: 20))
//
//                }
//                NavigationLink(destination: HowItWorksView()) {
//                    Text("How it Works").padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
//                        .font(Font.custom("New", size: 20))
//
//                }
            }.foregroundColor(.black).background(       Image("quantum-gradient").resizable().aspectRatio(contentMode: .fill).edgesIgnoringSafeArea(.all)
            )
        }    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
