//
//  RectangleButton.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/8/23.
//

import SwiftUI

struct RectangleButton: View {
    
    var backgroundColor = Color.white
    var textColor: Color = Color.black
    var label: String
    var height: CGFloat = 48
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: height)
                .foregroundColor(backgroundColor)
                .cornerRadius(10)
                .shadow(radius: 5)
            Text(label)
                .foregroundColor(textColor)
                .bold()
        }
    }
}
