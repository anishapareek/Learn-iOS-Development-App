//
//  TestResultView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/15/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model: ContentModel
    var numCorrect: Int
    @Binding var path: NavigationPath
    
    var resultHeading: String {
        // to make sure that we can force unwrap currentTest and the program won't crash
        guard model.currentTest != nil else {
            return ""
        }
        let pct = Double(numCorrect)/Double(model.currentTest!.questions.count)
        if pct > 0.5 {
            return "Awesome!"
        } else if pct > 0.2 {
            return "Doing great!"
        } else {
            return "Keep learning!"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(resultHeading)
                .font(.title)
            Spacer()
            Text("You got \(numCorrect) out of \(model.currentTest?.questions.count ?? 0) questions")
            Spacer()
            Button {
                // Take the user back to the homeView
                path.removeLast(path.count)
            } label: {
                RectangleButton(backgroundColor: .green, textColor: .white, label: "Complete")
                    .padding()
            }
            Spacer()
        }
    }
}
