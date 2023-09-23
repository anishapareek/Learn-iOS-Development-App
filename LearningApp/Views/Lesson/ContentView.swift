//
//  ContentView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    @Binding var path: NavigationPath
    var module: Module
    
    var body: some View {
        
        ScrollView {
            LazyVStack (alignment: .leading) {
                
                ForEach(0..<model.lessons.count, id: \.self) { index in
                    NavigationLink(value: model.lessons[index]) {
                        ContentViewRow(lesson: model.lessons[index], index: index)
                    }
                }
            }
            .accentColor(.black)
            .padding(.horizontal)
            .navigationTitle("Learn \(module.category)")
            .navigationDestination(for: Lesson.self) { lesson in
                ContentDetailView(currentLesson: lesson, path: $path)
                    .onAppear {
                        model.setLessonIndex(lesson: lesson)
                    }
            }
        }
    }
}

