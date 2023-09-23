//
//  HomeView.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/2/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ContentModel
    @State private var path = NavigationPath()
    let user = UserService.shared.user
    
    var navTitle: String {
        if user.lastLesson != nil || user.lastQuestion != nil {
            return "Welcome back!"
        } else {
            return "Get Started"
        }
    }
    
    var body: some View {
        NavigationStack (path: $path) {
            VStack (alignment: .leading) {
                if (user.lastLesson != nil && user.lastLesson != 0) ||
                    (user.lastQuestion != nil && user.lastQuestion != 0) {
                    
                    // TODO: - Navigate to the desired lesson/question
                    
                    NavigationLink(value: model.currentModuleId) {
                        ResumeView()
                            .padding(.horizontal)
                    }
                    .navigationDestination(for: String.self) { moduleId in
                        // pass the current module to display the quiz title
                        TestView(path: $path, moduleIndex: model.getModuleIndex())
                            .onAppear {
                                model.currentModuleId = moduleId
                                model.currentTest = model.modules[model.getModuleIndex()].test
                                model.getQuestions(module: model.modules[model.getModuleIndex()]) {
                                    model.beginTest(fromBeginning: false)
                                    model.currentQuestionIndex = UserService.shared.user.lastQuestion ?? 0
                                }
                            }
                    }
                    
//                    // Show the resume view
//                    ResumeView()
//                        .padding(.horizontal)
                } else {
                    Text("What do you want to do today?")
                        .padding(.leading)
                }
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(0..<model.modules.count, id: \.self) { index in
                            let module = model.modules[index]
                            NavigationLink(value: module) {
                                HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                            }
                            
                            NavigationLink(value: index) {
                                HomeViewRow(image: module.test.image, title: "Test \(module.category)", description: module.test.description, count: "\(module.test.questions.count) Questions", time: module.test
                                    .time)
                            }
                        }
                    }
                    .padding()
                    .accentColor(.black)
                }
            }
            .navigationTitle(navTitle)
            .navigationDestination(for: Module.self) { module in
                ContentView(path: $path, module: module)
                    .onAppear {
                        model.currentModuleId = module.id
                        model.saveData()
                        model.getLessons(module: module)
                    }
            }
            .navigationDestination(for: Int.self) { moduleIndex in
                // pass the current module to display the quiz title
                TestView(path: $path, moduleIndex: moduleIndex)
                    .onAppear {
                        model.currentQuestionIndex = 0
                        model.currentModuleId = model.modules[moduleIndex].id
                        model.currentTest = model.modules[moduleIndex].test
                        model.getQuestions(module: model.modules[moduleIndex]) {
                            model.beginTest()
                        }
                    }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
