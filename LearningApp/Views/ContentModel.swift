//
//  ContentModel.swift
//  LearningApp
//
//  Created by Anisha Pareek on 8/2/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift

@MainActor
class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var loggedIn = false
    @Published var modules = [Module]()
    @Published var lessons = [Lesson]()
    @Published var currentLessonIndex: Int = 0
    var currentModuleId: String?
    var styleData: Data?
    @Published var codeText = NSAttributedString()
    @Published var currentTest: Test?
    @Published var currentQuestion: Question?
    @Published var currentQuestionIndex = 0
    
    init() {
        
    }
    
    // MARK: - Authentication Methods
    func checkLogin() {
        // Check if there's a current user to determine logged in status
        self.loggedIn = Auth.auth().currentUser == nil ? false : true
        
        Task {
            // Check if user meta data has been fetched. If the user was already signed in
            // from a previos session, we need to get their data in a separate call
            await fetchUser()
        }
    }
    
    // MARK: - Login methods
    func signIn(withEmail email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)

        // Change the login view to logged in view
        checkLogin()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out the user on the backend
            resetCurrentUser() // wipes out the current user data model
            // change to the logged out view
            checkLogin()
        } catch {
            print("DEBUG: Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func resetCurrentUser() {
        UserService.shared.user.id = ""
        UserService.shared.user.firstName = ""
        UserService.shared.user.lastLesson = nil
        UserService.shared.user.lastModule = nil
        UserService.shared.user.lastQuestion = nil
    }
    
    func createAccount(withEmail email: String, password: String, name: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // save the first name
        let user = User(id: result.user.uid, firstName: name)
        let encodedUser = try Firestore.Encoder().encode(user)
        try await Firestore.firestore()
            .collection(Constants.collectionPath)
            .document(user.id)
            .setData(encodedUser, merge: true)
        
        // Update the user meta data
        await fetchUser()
        
        // Change the view to logged in view
        checkLogin()
    }
    
    // MARK: - Data Methods
    
    func saveData() {
        // Do it only if the user is logged in
        if Auth.auth().currentUser != nil {
            // Save the progress data locally
            let user = UserService.shared.user
            user.lastModule = currentModuleId
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
        }
    }
    
    func saveDataToDatabse() async {
        if Auth.auth().currentUser != nil {
            let user = UserService.shared.user
            // Save it to the database
            do {
                let encodedUser = try Firestore.Encoder().encode(user)
                try await Firestore.firestore()
                    .collection(Constants.collectionPath)
                    .document(user.id)
                    .setData(encodedUser, merge: true)
            } catch {
                print("DEBUG: Saving the data in database failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection(Constants.collectionPath)
            .document(uid)
            .getDocument() else { return }
        do {
            UserService.shared.user = try snapshot.data(as: User.self)
            print("Current user: \(UserService.shared.user.firstName)")
        } catch {
            print("DEBUG: Could not fetch the current user - \(error.localizedDescription)")
        }
        
    }
    
    func getLessons(module: Module){
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        // Get documents
        collection.getDocuments { snapshot, error in
            if let error {
                print("Unable to fetch lessons")
                print(error.localizedDescription)
            }
            // No error
            else if let snapshot {
                // Array to track lessons
                var lessons = [Lesson]()
                // Loop through the documents and build an array of lessons
                for doc in snapshot.documents {
                    // New lesson
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add it to our array
                    lessons.append(l)
                }
                
                // Set the lessons
                DispatchQueue.main.async {
                    self.lessons = lessons
                }
            }
        }
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("questions")
        // Get documents
        collection.getDocuments { snapshot, error in
            // Check for errors
            if let error {
                print("Could not fetch questions")
                print(error.localizedDescription)
            }
            // No errors
            else if let snapshot {
                // Array to track questions
                var questions = [Question]()
                
                // Loop through the documents
                for doc in snapshot.documents {
                    // New question
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["content"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? []
                    
                    // Add it to the array
                    questions.append(q)
                }
                // Setting the questions to the module
                // Loop through the published modules array and find the one that matches the copy that got passed in
                for (index, m) in self.modules.enumerated() {
                    // Find the module we want
                    if m.id == module.id {
                        // Set the questions
                        self.modules[index].test.questions = questions
                        self.currentTest?.questions = questions
                        completion()
                    }
                }
            }
        }
    }
    
    // get database modules
    func getModules() {
        
        // parse local style.html
        getLocalStyles()
        
        // Specify path
        let collection = db.collection("modules")
        //        let snapshot = try? await collection.getDocuments()
        // get documents
        collection.getDocuments { snapshot, error in
            // Check for errors
            if let error {
                print("Could not retrieve documents.")
                print(error.localizedDescription)
            }
            // No errors
            else if let snapshot {
                // Create an array for the modules
                var modules = [Module]()
                
                // Loop through the documents returned
                for doc in snapshot.documents {
                    // Create a new module instance
                    var m = Module()
                    
                    // Parse out the values from the document into the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse the lesson content
                    let contentMap = doc["content"] as! [String: Any]
                    
                    m.content.id = contentMap["id"] as? String ?? UUID().uuidString
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    
                    // Parse the test content
                    let testMap = doc["test"] as! [String: Any]
                    
                    m.test.id = testMap["id"] as? String ?? UUID().uuidString
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    
                    // Add it to our array
                    modules.append(m)
                }
                
                // Assign our modules to the published property
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
    }
    
    func getLocalStyles() {
        
        // Parse the style data
        // Get url to the style file
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        if let styleUrl {
            do {
                // Read the file into a data object
                let styleData = try Data(contentsOf: styleUrl)
                self.styleData = styleData
                
            } catch {
                print("Couldn't read the style file into a data object.")
            }
        } else {
            print("Could not get the url to the style file.")
        }
    }
    
    func hasNextLesson() -> Bool {
        return currentLessonIndex < (lessons.count-1)
    }
    
    // MARK: - Code Styling
    func addStyling(_ htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        
        var data = Data()
        
        // Add the styling data
        if let styleData {
            data.append(styleData)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed String
        // MARK: - Technique 1
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html],documentAttributes: nil) {
            resultString = attributedString
        }
        
        //         MARK: - Technique 2
        //         This will allow us to catch and handle the error thrown
        //        do {
        //            resultString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        //        } catch {
        //            print("Couldn't turn html into an attributed string")
        //        }
        
        return resultString
    }
    
    func nextLesson(text: String?) {
        if let text {
            codeText = addStyling(text)
        }
    }
    
    func beginTest(fromBeginning: Bool = true) {
        // Reset the lesson index since they are starting a test now
        currentLessonIndex = 0
        
        if fromBeginning {
            // Set the current question index
            currentQuestionIndex = 0
        }
        
        if let currentTest {
            if currentTest.questions.count > 0 {
                self.currentQuestion = currentTest.questions[currentQuestionIndex]
                self.codeText = addStyling(currentTest.questions[currentQuestionIndex].content)
            }
        }
    }
    
    func nextQuestion() {
        
        currentQuestionIndex += 1
        if currentQuestionIndex < currentTest?.questions.count ?? 0 {
            currentQuestion = currentTest?.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion?.content ?? "")
        } else {
            // If not then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        saveData()
    }
    
    // MARK: - Helper Methods
    func getModuleName() -> String {
        let user = UserService.shared.user
        for module in self.modules {
            if module.id == user.lastModule {
                return module.category
            }
        }
        return ""
    }
    
    func getModuleIndex() -> Int {
        let user = UserService.shared.user
        for (index, module) in self.modules.enumerated() {
            if module.id == user.lastModule {
                return index
            }
        }
        return 0
    }
    
    func setLessonIndex(lesson: Lesson) {
        for (index, l) in lessons.enumerated() {
            if l.id == lesson.id {
                self.currentLessonIndex = index
                return
            }
        }
    }
}
