import Foundation

protocol DataCache {
    var items: [String: TodoItem] { get }
    var itemsSorted: [TodoItem] { get  }
    var isDirty: Bool { get set }
    
    func add(_ item: TodoItem)
    func save(toFile file: String, format: FormatToSave) throws
    func load(from file: String, format: FormatToSave) throws
    @discardableResult func remove(id: String) -> TodoItem?
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
