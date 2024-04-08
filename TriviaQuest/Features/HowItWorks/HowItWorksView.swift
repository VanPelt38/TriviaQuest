//
//  HowItWorksView.swift
//  TriviaQuest
//
//  Created by Jake Gordon on 08/04/2024.
//

import SwiftUI

struct HowItWorksView: View {
    var body: some View {
        VStack {
            Text("How it Works").padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("Permanent Marker Regular", size: 48))
            Text("Welcome to Trivia Quest - where your knowledge will be tested to its limits and beyond. ").padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("Permanent Marker Regular", size: 15)).multilineTextAlignment(.center)
            Text("Tap 'Let's Play!' to receive 15 random trivia questions in categories ranging from Art to Science & Nature. ").padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("Permanent Marker Regular", size: 15)).multilineTextAlignment(.center)
            Text("Try and get as many as you can right! There are easy, medium, and hard questions, but be careful: you only have one chance to answer correctly.").padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("Permanent Marker Regular", size: 15)).multilineTextAlignment(.center)
            Text("Once you've finished answering all your questions, tap 'Refresh Questions' to load a brand new set. Good luck!").padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20)).font(Font.custom("Permanent Marker Regular", size: 15)).multilineTextAlignment(.center)
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

struct HowItWorksView_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorksView()
    }
}
