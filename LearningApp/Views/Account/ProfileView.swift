//
//  ProfileView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/22/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        Button {
            // Sign out the user
            model.signOut()
        } label: {
            Text("Sign Out")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
