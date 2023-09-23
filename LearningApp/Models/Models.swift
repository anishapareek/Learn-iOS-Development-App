//
//  Models.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/2/23.
//

import Foundation


struct Module: Decodable, Identifiable, Hashable {
    var id: String = ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
}

struct Content: Decodable, Identifiable, Hashable {
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
}

struct Lesson: Decodable, Identifiable, Hashable {
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
}

struct Test: Decodable, Identifiable, Hashable {
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

struct Question: Decodable, Identifiable, Hashable {
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
}

class User: Identifiable, Codable {
    var id: String = ""
    var firstName: String = ""
    var lastModule: String?
    var lastLesson: Int?
    var lastQuestion: Int?
    
    init() {}
    
    init(id: String, firstName: String) {
        self.id = id
        self.firstName = firstName
    }
}
