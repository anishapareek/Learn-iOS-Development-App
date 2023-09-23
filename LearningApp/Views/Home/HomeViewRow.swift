//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/5/23.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var title: String
    var description: String
    var count: String
    var time: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Spacer()
                VStack (alignment: .leading, spacing: 10) {
                    Text(title)
                        .bold()
                        .font(.title3)
                    Text(description)
                        .padding(.bottom)
                        .font(.caption)
                    HStack {
                        Image(systemName: "text.book.closed")
                        Text(count)
                            .font(Font.system(size: 10))
                        Spacer()
                        Image(systemName: "clock")
                        Text(time)
                            .font(Font.system(size: 10))
                    }
                    
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "some description", count: "10 Lessons", time: "2 hours")
    }
}
