//
//  CSVService.swift
//  ToDoProject
//


import Foundation

extension TodoItem {
    static func parse( csv: String) -> TodoItem? {
        let components = csv.components(separatedBy: ",")
        
        guard components.count >= 6 else {
            return nil
        }
        
        let id = components[0]
        let text = components[1]
        
        guard let importance = Importance(rawValue: components[2]) else {
            return nil
        }
        
        var deadline: Date? = nil
        if !components[3].isEmpty {
            if let deadlineTimestamp = TimeInterval(components[3]) {
                deadline = Date(timeIntervalSince1970: deadlineTimestamp)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                deadline = dateFormatter.date(from: components[3])
            }
        }
        
        let isCompletedString = components[4]
        let dateCreatedTimestamp = TimeInterval(components[5])
        let dateChangedTimeStamp = TimeInterval(components[6])
        
        
        
        let isCompleted = (isCompletedString == "1")
        let dateCreated = Date(timeIntervalSince1970: dateCreatedTimestamp ?? 0)
        let dateChanged = Date(timeIntervalSince1970: dateChangedTimeStamp ?? 0)
        
        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isCompleted: isCompleted,
                        dateCreated: dateCreated,
                        dateChanged: dateChanged)
    }
    
    var csv: String {
        var csvString = "\(id),\(text),\(importance.rawValue),"
        
        if let deadline = deadline {
            let deadlineValue: String
            let deadlineTimestamp = deadline.timeIntervalSince1970
            if deadlineTimestamp.isNaN {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                deadlineValue = dateFormatter.string(from: deadline)
            } else {
                deadlineValue = "\(deadlineTimestamp)"
            }
            csvString += "\(deadlineValue),"
        } else {
            csvString += ","
        }
        
        csvString += "\(isCompleted ? 1 : 0),\(dateCreated.timeIntervalSince1970),"
        
        if let dateChanged = dateChanged {
            csvString += "\(dateChanged.timeIntervalSince1970)"
        }
        
        return csvString
    }
}
