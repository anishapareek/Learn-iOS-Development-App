//
//  ResumeView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/23/23.
//

import SwiftUI

struct ResumeView: View {
    @EnvironmentObject var model: ContentModel
    let user = UserService.shared.user
    
    var resumeTitle: String {
        let moduleName = model.getModuleName()
        if user.lastLesson != nil && user.lastLesson! != 0 {
            // Resume a lesson
            return "Learn \(moduleName): Lesson \(user.lastLesson! + 1)"
        } else if let lastQuestion = user.lastQuestion {
            // Resume a test
            return "\(moduleName) Test: Question \(lastQuestion + 1)"
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 66)
                .cornerRadius(10)
                .shadow(radius: 10)
            HStack {
                VStack(alignment: .leading) {
                    Text("Continue where you left off:")
                    Text(resumeTitle)
                        .bold()
                }
                Spacer()
                Image("play")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal)
        }
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
            .environmentObject(ContentModel())
    }
}
