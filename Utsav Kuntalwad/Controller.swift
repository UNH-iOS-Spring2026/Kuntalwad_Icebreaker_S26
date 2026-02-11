//
//  ContentView.swift
//  Kuntalwad_Icebreaker_S26
//
//  Created by Utsav Kuntalwad on 1/30/26.
//

import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    let db = Firestore.firestore()
    
    @State var txtFirstName: String = ""
    @State var txtLastName: String = ""
    @State var txtPrefName: String = ""
    @State var txtQuestion: String = ""
    @State var txtAnswer: String = ""
    
    @State var questions = [Question]()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Icebreaker")
                .bold()
                .font(.system(size: 40))
            Text("Made By Professor Pellicano")
            Spacer()
            TextField("First Name", text: $txtFirstName)
            TextField("Last Name", text: $txtLastName)
            TextField("Preferred Name", text: $txtPrefName)
            Button(action: {
                setRandomQuestion()
            }){
                Text("Get a new random question")
                    .font(.system(size: 28))
            }
            Text(txtQuestion)
            TextField("Answer", text: $txtAnswer)
            Button(action: {
                writeStudentToFirebase()
                resetTxtFields()
            }){
                Text("Submit")
                    .font(.system(size: 28))
            }
            .padding(30)

            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .onAppear(){
            getQuestionsFromFirebase()
        }
    }
    
    func setRandomQuestion(){
        let newQuestion = questions.randomElement()?.text
        if(newQuestion != nil){
            self.txtQuestion = newQuestion!
        }
    }
    
    func getQuestionsFromFirebase(){
        db.collection("questions")
            .getDocuments(){ (QuerySnapshot, err) in
                if let err = err { // error not nil
                        print("Error getting documents: \(err)")
                } else {
                    for document in QuerySnapshot!.documents {
                        print("Document ID: \(document.documentID)")
                        if let question = Question(id: document.documentID, data: document.data()){
                            print("Quesiton ID: \(question.id), text = \(question.text)")
                            
                            self.questions.append(question)
                        }
                    }
                }
                
            }
    }
    
    func writeStudentToFirebase(){
        let data = [
            "first_name" : txtFirstName,
            "last_name" : txtLastName,
            "pref_name" : txtPrefName,
            "question" : txtQuestion,
            "answer" : txtAnswer,
            "class"  : "iOS-Spring2026"
        ] as [String : Any]
        
        var ref: DocumentReference? = nil
        
        ref = db.collection("students")
            .addDocument(data: data) { err in
                if let err = err {
                    print("error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
    }
    
    func resetTxtFields(){
        txtFirstName = ""
        txtLastName = ""
        txtPrefName = ""
        txtAnswer = ""
        txtQuestion = ""
    }
    
}

#Preview {
    ContentView()
}
