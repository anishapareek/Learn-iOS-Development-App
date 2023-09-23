//
//  LoginView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/22/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Constants.LoginMode.login
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var errorMessage: String?
    
    var buttonText: String {
        if loginMode == Constants.LoginMode.login {
            return "Log In"
        }
        return "Sign Up"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Group {
                // Logo
                Image(systemName: "book")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150)
                
                // Title
                Text("Learnzilla")
                    .font(.title)
            }
            Spacer()
            // Picker
            Picker(selection: $loginMode) {
                Text("Login")
                    .tag(Constants.LoginMode.login)
                Text("Sign Up")
                    .tag(Constants.LoginMode.createAccount)
            } label: {
                Text("")
            }
            .pickerStyle(.segmented)

            // Form
            Group {
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
                
                TextField("Email", text: $email)
                
                SecureField("Password", text: $password)
                
                if let errorMessage {
                    Text(errorMessage)
                }
                
                // Button
                Button {
                    if loginMode == Constants.LoginMode.login {
                        // Log the user in
                        Task {
                            do {
                                try await model.signIn(withEmail: email, password: password)
                                // Clear error message
                                self.errorMessage = nil
                            } catch {
                                print("DEBUG: Failed to login with error: \(error.localizedDescription)")
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    } else {
                        // Create a new account
                        Task {
                            do {
                                try await model.createAccount(withEmail: email, password: password, name: name)
                                // Clear error message
                                self.errorMessage = nil
                            } catch {
                                print("DEBUG: Failed to sign up with error: \(error.localizedDescription)")
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.blue)
                            .frame(height: 40)
                            .cornerRadius(10)
                        Text(buttonText)
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 30)
        .textFieldStyle(.roundedBorder)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
