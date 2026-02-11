//
//  Question.swift
//  Kuntalwad_Icebreaker_S26
//
//  Created by Utsav Kuntalwad on 01/30/26.
//

import Foundation

class Question {
    var id: String
    var text: String
    
    init?(id: String, data: [String: Any]){
        guard let text = data["text"] as? String
        else {
            return nil
        }
        self.id = id
        self.text = text
    }
}
