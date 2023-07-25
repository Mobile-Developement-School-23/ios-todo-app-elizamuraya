import Foundation

protocol DataCache {
    var items: [String: TodoItem] { get }
    var itemsSorted: [TodoItem] { get  }
    var isDirty: Bool { get set }
    
    func add(_ item: TodoItem)
    @discardableResult func remove(id: String) -> TodoItem?
    func save(toFile file: String, format: FormatToSave) throws
    func load(from file: String, format: FormatToSave) throws

}

enum FormatToSave {
    case json
    case csv
}

enum FileCacheError: Error {
    case unparseableData
    case cantFindSystemDirectory
}

final class FileCache: DataCache {

    private(set) var items: [String: TodoItem] = [:]
    var isDirty: Bool = false
    var itemsSorted: [TodoItem] {
        items.sorted { $0.value.dateCreated < $1.value.dateCreated }.map { $1 }
    }
    
    // MARK: – ADD ITEM
    func add(_ item: TodoItem) {
        items[item.id] = item
    }
    
    // MARK: - SAVE ITEM
    func save(toFile file: String, format: FormatToSave) throws {
        let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        switch format {
        case .json:
            let url = dir.appending(path: file + ".json")
            let itemsJSON = items.map(\.value.json)
            let jsonData = try JSONSerialization.data(withJSONObject: itemsJSON, options: .prettyPrinted)
            try jsonData.write(to: url, options: .atomic)
        case .csv:
            let url = dir.appending(path: file + ".csv")
            let itemsJSON = items.map(\.value.csv)
            let jsonData = try JSONSerialization.data(withJSONObject: itemsJSON, options: .prettyPrinted)
            try jsonData.write(to: url, options: .atomic)
        }
    }
    
    // MARK: – LOAD ITEM
    func load(from file: String, format: FormatToSave) throws {
        let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        var todoItems = [TodoItem]()
        
        switch format {
        case .json:
            let url = dir.appending(path: file + ".json")
            let data = try Data(contentsOf: url)
            let jsonData = try JSONSerialization.jsonObject(with: data)
            guard let arrJSON = jsonData as? [Any] else { throw FileCacheError.unparseableData }
            todoItems = arrJSON.compactMap { TodoItem.parse(json: $0) }
        case .csv:
            let url = dir.appending(path: file + ".csv")
            let data = try String(contentsOf: url).split(separator: "\n").map(String.init)
            todoItems = data.compactMap { TodoItem.parse(csv: $0) }
        }
        for item in todoItems {
            add(item)
        }
    }

    // MARK: – DELETE ITEM
    @discardableResult
    func remove(id: String) -> TodoItem? {
        let removedItem = items.removeValue(forKey: id)
        return removedItem
    }
}


// MARK: – JSON

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


// MARK: – CSV

extension TodoItem {
    static func parse( csv: String) -> TodoItem? {
        let components = csv.components(separatedBy: ",")
        
        guard components.count >= 6,
              !components[0].isEmpty,
              !components[1].isEmpty,
              let dateCreated = Int(components[5]).flatMap({Date(timeIntervalSince1970: TimeInterval($0))})
        else {
            return nil
        }
        
        let id = components[0]
        let text = components[1]
        let importance = Importance(rawValue: components[2]) ?? .normal
        
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
       // let dateCreatedTimestamp = TimeInterval(components[5])
        let dateChangedTimeStamp = TimeInterval(components[6])
        
        
        let isCompleted = (isCompletedString == "1")
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

