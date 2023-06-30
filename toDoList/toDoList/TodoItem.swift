import Foundation
public enum Importance: String {
   case low
   case normal
   case high
}
public struct TodoItem {
    public let id: String
    public let text: String
    public let importance: Importance
    public let deadline: Date?
    public let isCompleted: Bool
    public let dateCreated: Date
    public let dateChanged: Date?
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
