import Foundation
import CoreData

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

extension TodoItem {
    static func convert(from networkToDoItem: NetworkToDoItem) -> TodoItem {
        var importance = Importance.normal
        switch networkToDoItem.importance {
        case "low":
            importance = .low
        case "basic":
            importance = .normal
        case "important":
            importance = .high
        default:
            break
        }
        var deadline: Date?
        if let deadlineTimeInterval = networkToDoItem.deadline {
            deadline = Date(timeIntervalSinceReferenceDate: Double(deadlineTimeInterval))
        }
        var changed: Date?
        if let changedTimeInterval = networkToDoItem.changedAt {
            changed = Date(timeIntervalSinceReferenceDate: Double(changedTimeInterval))
        }
        let created = Date(timeIntervalSinceReferenceDate: Double(networkToDoItem.createdAt))
        let toDoItem = TodoItem(id: networkToDoItem.id, text: networkToDoItem.text, importance: importance, deadline: deadline, isCompleted: networkToDoItem.done, dateCreated: created, dateChanged: changed)
        return toDoItem
    }
    
    var networkItem: NetworkToDoItem {
            var importance = ""
            switch self.importance {
                case .low:
                    importance = "low"
                case .normal:
                    importance = "basic"
                case .high:
                    importance = "important"
            }
            let created = Int(self.dateCreated.timeIntervalSinceReferenceDate)
            let networkItem = NetworkToDoItem(id: id, text: text, importance: importance, done: isCompleted, createdAt: created)
            return networkItem
        }
}

extension TodoItem {
    static func convert(from CoreDataItem: Entity) -> TodoItem {
        TodoItem(id: CoreDataItem.id,
                 text: CoreDataItem.text,
                 importance: Importance(rawValue: CoreDataItem.importance) ?? .normal,
                 deadline: CoreDataItem.deadline,
                 isCompleted: CoreDataItem.isCompleted,
                 dateCreated: CoreDataItem.dateCreated,
                 dateChanged: CoreDataItem.dateChanged)
    }
    static func convert(from toDoItem: TodoItem, with context: NSManagedObjectContext) -> Entity {
        let cdItem = Entity(context: context)
        cdItem.id = toDoItem.id
        cdItem.text = toDoItem.text
        cdItem.importance = toDoItem.importance.rawValue
        cdItem.deadline = toDoItem.deadline
        cdItem.isCompleted = toDoItem.isCompleted
        cdItem.dateCreated = toDoItem.dateCreated
        cdItem.dateChanged = toDoItem.dateChanged
        return cdItem
    }
}
