//
//  TestView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/11/23.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex: Int?
    @State var numCorrect = 0
    @State var submitted = false
    @Binding var path: NavigationPath
    var moduleIndex: Int
    
    var buttonText: String {
        if submitted {
            if (model.currentQuestionIndex + 1) == model.currentTest?.questions.count {
                return "Finish"
            } else {
                return "Next"
            }
        }
        return "Submit"
    }
    
    var body: some View {
        if let currentQuestion = model.currentQuestion {
            let title = "Test \(model.modules[moduleIndex].category)"
            VStack (alignment: .leading) {
                
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentTest?.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                
                ScrollView {
                    
                    VStack {
                        ForEach(0..<currentQuestion.answers.count, id: \.self) { index in
                            
                            Button {
                                selectedAnswerIndex = index
                            } label: {
                                // Answers
                                if !submitted {
                                    // default background color of white, default text color of black, default height
                                    RectangleButton(backgroundColor: (selectedAnswerIndex == index ? .gray : .white), label: currentQuestion.answers[index])
                                } else {
                                    // Answer has been submitted
                                    if index == currentQuestion.correctIndex {
                                        // user has selected the right answer
                                        // Show a green background
                                        // default height
                                        RectangleButton(backgroundColor: .green, textColor: .white, label: currentQuestion.answers[index])
                                    } else if index == selectedAnswerIndex && index != currentQuestion.correctIndex {
                                        // User has selected the wrong answer
                                        // Show a red background
                                        // default height
                                        RectangleButton(backgroundColor: .red, textColor: .white, label: currentQuestion.answers[index])
                                    } else {
                                        // default background color of white, default text color of black, default height
                                        RectangleButton(label: currentQuestion.answers[index])
                                    }
                                }
                            }
                            .disabled(submitted)
                        }
                    }
                    .padding()
                    
                }
                // Button
                Button {
                    // Check if answer has been submitted
                    if submitted {
                        // Answer has already been submitted, move to the next question
                        model.nextQuestion()
                        
                        // Reset properties
                        selectedAnswerIndex = nil
                        submitted = false
                        
                    } else {
                        // Submit the answer
                        // Change submitted state to true
                        submitted = true
                        // Check the answer and increment the counter if correct
                        if selectedAnswerIndex == currentQuestion.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    RectangleButton(backgroundColor: .green, textColor: .white, label: buttonText)
                        .padding(.horizontal)
                }
                .disabled(selectedAnswerIndex == nil)
            }
            .padding(.horizontal)
            .navigationTitle(title)
        }
        else {
            TestResultView(numCorrect: numCorrect, path: $path)
        }
    }
}

