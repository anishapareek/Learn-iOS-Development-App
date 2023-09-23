//
//  UserService.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/23/23.
//

import Foundation

class UserService {
    var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
