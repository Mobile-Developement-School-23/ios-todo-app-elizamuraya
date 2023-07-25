import Foundation

struct Task: Identifiable {
    let id = UUID()
    var text: String
    var isDone = false
    var isImportant = false
    var deadline: Date? = nil
}


public enum Importance: String {
   case low
   case normal
   case high
}
struct TodoItem {
    let id: String
    let text: String
    let importance: Importance
    var deadline: Date?
    var isCompleted: Bool
    let dateCreated: Date
    let dateChanged: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance = .normal, deadline: Date? = nil, isCompleted: Bool = false, dateCreated: Date = Date(), dateChanged: Date? = Date()) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
        self.dateChanged = dateChanged
    }
}
