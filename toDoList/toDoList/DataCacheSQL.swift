import Foundation
import SQLite

final class DataCacheSQL {
    
    private(set) var items = [String: TodoItem]()
    private let serialQueue = DispatchQueue(label: "serialQueue", qos: .background)
    
    private var db: Connection!
    private var todoItems: Table!
    
    private var id: Expression<String>!
    private var text: Expression<String>!
    private var importance: Expression<String>!
    private var deadline: Expression<Int?>!
    private var isCompleted: Expression<Bool>!
    private var dateCreated: Expression<Int>!
    private var dateChanged: Expression<Int?>!
    
    init () {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
          //  print("sql path: \(path)" )
            db = try Connection("\(path)/TodoItems.sqlite3")
            todoItems = Table("TodoItems")
        
            id = Expression<String>("id")
            text = Expression<String>("text")
            importance = Expression<String>("importance")
            deadline = Expression<Int?>("deadline")
            isCompleted = Expression<Bool>("isCompleted")
            dateCreated = Expression<Int>("dateCreated")
            dateChanged = Expression<Int?>("dateChanged")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                try db.run(todoItems.create { table in
                    table.column(id, primaryKey: true)
                    table.column(text)
                    table.column(importance)
                    table.column(deadline)
                    table.column(isCompleted)
                    table.column(dateCreated)
                    table.column(dateChanged)
                })
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func insert(item: TodoItem) {
        items[item.id] = item
        serialQueue.async {
            self.insertTodoItem(item: item)
        }
    }
    
    private func insertTodoItem(item: TodoItem) {
        let deadlineInt: Int? = item.deadline?.timeIntervalSince1970.toInt()
        let dateCreationInt = item.dateCreated.timeIntervalSince1970.toInt()
        let dateChangingInt: Int? = item.dateChanged?.timeIntervalSince1970.toInt()

        do {
            try db.run(todoItems.insert(
                id <- item.id,
                text <- item.text,
                importance <- item.importance.rawValue,
                deadline <- deadlineInt,
                isCompleted <- item.isCompleted,
                dateCreated <- dateCreationInt,
                dateChanged <- dateChangingInt
            ))
        } catch {
            print(error.localizedDescription)
        }
    }

    public func load() {
        loadTodoItems().forEach{items[$0.id] = $0}
    }
    
    public func loadTodoItems() -> [TodoItem] {
        var resultList = [TodoItem]()
        todoItems = todoItems.order(id.desc)
        do {
            for item in try db.prepare(todoItems) {
                let importanceString = item[importance]
                let deadlineInt = item[deadline]
                let dateCreationInt = item[dateCreated]
                let dateChangingInt = item[dateChanged]
                
                var deadline: Date?
                if let deadlineInt {
                    let timeinterval = TimeInterval(deadlineInt)
                    deadline = Date(timeIntervalSince1970: timeinterval)
                }
                
                var dateChanging: Date?
                if let dateChangingInt {
                    let timeinterval = TimeInterval(dateChangingInt)
                    dateChanging = Date(timeIntervalSince1970: timeinterval)
                }
                
                
                let todoItem = TodoItem(id: item[id],
                                        text: item[text],
                                        importance: Importance(rawValue: importanceString) ?? .normal,
                                        deadline: deadline,
                                        isCompleted: item[isCompleted],
                                        dateCreated: Date(timeIntervalSince1970: TimeInterval(dateCreationInt)),
                                        dateChanged: dateChanging)
                resultList.append(todoItem)
            }
        } catch {
            print(error.localizedDescription)
        }
        return resultList
    }
    
    public func update(item: TodoItem) {
        items[item.id] = item
        serialQueue.async {
            self.updateTodoItem(idValue: item.id, newTodoItem: item)
        }
    }
    
    private func updateTodoItem(idValue: String, newTodoItem: TodoItem) {
        let deadlineInt: Int? = newTodoItem.deadline?.timeIntervalSince1970.toInt()
        let dateCreationInt = newTodoItem.dateCreated.timeIntervalSince1970.toInt()
        let dateChangingInt: Int? = newTodoItem.dateChanged?.timeIntervalSince1970.toInt()

        do {
            let todoItem = todoItems.filter(id == idValue).limit(1)
            try db.run(todoItem.update(
                id <- newTodoItem.id,
                text <- newTodoItem.text,
                importance <- newTodoItem.importance.rawValue,
                deadline <- deadlineInt,
                isCompleted <- newTodoItem.isCompleted,
                dateCreated <- dateCreationInt,
                dateChanged <- dateChangingInt
            ))
        } catch {
            print(error.localizedDescription)
        }
    }

    
    @discardableResult
    public func delete(id: String) -> TodoItem? {
        print(items)
        let deleted = items[id]
        items[id] = nil
        serialQueue.async {
            self.deleteTodoItem(idValue: id)
        }
        return deleted
    }
    
    private func deleteTodoItem(idValue: String) {
        do {
            let todoItem = todoItems.filter(id == idValue).limit(1)
            try db.run(todoItem.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension TimeInterval {
    func toInt() -> Int {
        return Int(self)
    }
}
