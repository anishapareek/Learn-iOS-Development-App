# GoGrow

It is a learning app that can be used to learn about Swift and SwiftUI. There are multiple modules for different subjects and the user can resume from the module they were last reading. 
After going through the modules and learning about a subject, the user can complete an assessment to assess his knowledge in the concerned subject. The assessment can also be resumed from where the user left. Finally, the user is shown the score achieved after completing the assessment. 

The app is developed in SwiftUI and MVVM architecture pattern is followed for code organization. 

This app contains two major components - one features for learning and the second features for assessment.

Firebase Authnetication is used for account creation and login. 
The app will be powered with data fetched from the Firestore database.
The app tracks the user's progress and will allow the user to resume back from the lesson/quiz where he/she left off. 
User can watch a video in the app using a video player for better understanding.
 
The user will have to first create an account and login. Thereafter, the user will see a resume button (only if there was any progress) which will take the user to the lesson/quiz question where the user had left off. The user will also be able to navigate through a list of modules which includes learning modules and tests. 
Upon drilling into a learning module, the user will be presented with a list of lessons and then drilling into a particular lesson, the user is going to see a video, which is the main teaching component and also a description below the video. The user will have also have button to navigate to the next lesson and when all the lessons are completed, the user can drill back up to the main module and take a test. 
The test will contain a series of multiple choice questions and by the end of it, a result screen will be showed with the user's score in the test. 
