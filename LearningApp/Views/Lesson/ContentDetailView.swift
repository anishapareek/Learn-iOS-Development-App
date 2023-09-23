//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/5/23.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var currentLesson: Lesson
    @Binding var path: NavigationPath
    
    var body: some View {
        
        let url = URL(string: Constants.videoHostUrl + (currentLesson.video))
        
        VStack {
            // Only show video if we get a valid url
            if let url {
                VideoPlayer(player: AVPlayer(url: url))
                    .cornerRadius(15)
            }
            
            // TODO: Description
            CodeTextView()
            
            // Show next lesson button, only if there is a next lesson
            if model.hasNextLesson() {
                Button {
                    // Advance the lesson index
                    model.currentLessonIndex += 1
                    // Advance the lesson
                    currentLesson = model.lessons[model.currentLessonIndex]
                    model.nextLesson(text: currentLesson.explanation)
                } label: {
                    let nextLessonTitle = (model.lessons[model.currentLessonIndex+1].title)
                    
                    RectangleButton(backgroundColor: .green, textColor: .white, label: "Next Lesson: \(nextLessonTitle)")
                }

            } else {
                // Show the complete button instead
                Button {
                    model.currentLessonIndex = 0
                    // Save progress
                    model.nextLesson(text: nil)
                    // Take the user back to the homeView
                    path.removeLast(path.count)
                } label: {
                    RectangleButton(backgroundColor: .green, textColor: .white, label: "Complete")
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(currentLesson.title)
        .onAppear {
            model.codeText = model.addStyling(currentLesson.explanation)
            model.saveData()
        }
    }
}

