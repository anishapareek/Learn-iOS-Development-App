//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/5/23.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var lesson: Lesson
    var index: Int
    
    var body: some View {
        // Lesson card
        ZStack {
            Rectangle()
                .frame(height: 86)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            HStack (spacing: 30) {
                Text("\(index+1)")
                    .bold()
                    .font(.title)
                VStack (alignment: .leading, spacing: 5) {
                    Text(lesson.title)
                        .bold()
                        .font(.title3)
                    Text(lesson.duration)
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        
    }
}

