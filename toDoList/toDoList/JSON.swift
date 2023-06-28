//
//  Todo JSON.swift
//  ToDoProject


import Foundation

extension TodoItem {
     static func parse(json: Any) -> TodoItem? {
        
        guard let json = json as? [String: Any],
              let id = json["id"] as? String,
              let text = json["text"] as? String,
              let dateCreatedInt = json["dateCreated"] as? Int else {
            return nil
        }
        
        var importance: Importance = .normal
        if let importanceRawValue = json["importance"] as? String {
            importance = Importance(rawValue: importanceRawValue) ?? .normal
        }
        
        var deadline: Date?
        if let deadlineInt = json["deadline"] as? Int { deadline = Date(timeIntervalSince1970: TimeInterval(deadlineInt))}
        
        let isCompleted = json["isCompleted"] as? Bool ?? false
    
        let dateCreated = Date(timeIntervalSince1970: TimeInterval(dateCreatedInt))
    
        var dateChanged: Date?
        if let dateChangedInt = json["dateChanged"] as? Int {
            dateChanged = Date(timeIntervalSince1970: TimeInterval(dateChangedInt))
        }
        
        return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, dateCreated: dateCreated, dateChanged: dateChanged)
    }
    


    
    var json: Any {
        var res: [String: Any] = [
        "id": id,
        "text": text,
        "isCompleted": isCompleted,
        "dateCreated": Int(dateCreated.timeIntervalSince1970)
        ]
        if importance != .normal {
            res["importance"] = importance.rawValue
        }
        if let deadline = deadline {
            res["deadline"] = Int(deadline.timeIntervalSince1970)
        }

        if let dateChanged = dateChanged {
            res["dateChanged"] = Int(dateChanged.timeIntervalSince1970)
        }
        return res
    }
    
 
}



extension Date {
    
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) ?? Date()
        return localDate
    }
}



