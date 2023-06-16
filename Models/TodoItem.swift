//
//  TodoItem.swift
//  ToDoProject
//

import Foundation

enum Importance: String {
   case high
   case normal
   case low
}


struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isCompleted: Bool
    let dateCreated: Date
    let dateChanged: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isCompleted: Bool = false, dateCreated: Date, dateChanged: Date?) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
        self.dateChanged = dateChanged
    }
}

