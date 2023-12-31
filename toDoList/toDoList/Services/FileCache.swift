import Foundation
import CoreData

protocol DataCache {
    var items: [String: TodoItem] { get }
    var itemsSorted: [TodoItem] { get  }
    var isDirty: Bool { get set }
    
    func add(_ item: TodoItem)
    @discardableResult func remove(id: String) -> TodoItem?
    func save(toFile file: String, format: FormatToSave) throws
    func load(from file: String, format: FormatToSave) throws
    
    // MARK: – CoreData
    func loadFromCoreData() async throws
    func insertInCoreData(toDoItem: TodoItem) async throws
    func deleteInCoreData(toDoItem: TodoItem) async throws
    func updateCoreData(toDoItem: TodoItem) async throws
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
    init(items: [String : TodoItem] = [:], isDirty: Bool = false, context: NSManagedObjectContext) {
        self.items = items
        self.isDirty = isDirty
        self.context = context
    }
    func loadFromCoreData() async throws {
        guard let context else { throw FileCacheError.unparseableData }
        let cdItems = try context.fetch(Entity.fetchRequest())
        let toDoItems = cdItems.map { TodoItem.convert(from: $0) }
        for toDoItem in toDoItems {
            add(toDoItem)
        }
    }
    
    func insertInCoreData(toDoItem: TodoItem) async throws {
        guard let context else { throw FileCacheError.unparseableData }
        let cdItem = TodoItem.convert(from: toDoItem, with: context)
        print(cdItem)
        try context.save()
    }
    
    func updateCoreData(toDoItem: TodoItem) async throws {
        guard let context else { throw FileCacheError.unparseableData }
        guard let coreDataItem = try await getInCoreData(toDoItem: toDoItem) else { return }
        coreDataItem.id = toDoItem.id
        coreDataItem.text = toDoItem.text
        coreDataItem.importance = toDoItem.importance.rawValue
        coreDataItem.deadline = toDoItem.deadline
        coreDataItem.isCompleted = toDoItem.isCompleted
        coreDataItem.dateCreated = toDoItem.dateCreated
        coreDataItem.dateChanged = toDoItem.dateChanged
        if context.hasChanges {
            try context.save()
        }
    }
    
    
    
    func deleteInCoreData(toDoItem: TodoItem) async throws {
        guard let context else { throw FileCacheError.unparseableData }
        guard let cdItem = try await getInCoreData(toDoItem: toDoItem) else { return }
        print(cdItem)
        context.delete(cdItem)
        try context.save()
    }
    
    func getInCoreData(toDoItem: TodoItem) async throws -> Entity? {
        guard let context else { throw FileCacheError.unparseableData }
        let request = Entity.fetchRequest()
        let predicate = NSPredicate(format: "id CONTAINS %@", toDoItem.id)
        request.predicate = predicate
        let cdItems = try context.fetch(request)
        print(cdItems.first as Any)
        return cdItems.first
    }
    
    private(set) var items: [String: TodoItem] = [:]
    var isDirty: Bool = false
    var itemsSorted: [TodoItem] {
        items.sorted { $0.value.dateCreated < $1.value.dateCreated }.map { $1 }
    }
    
    private let context: NSManagedObjectContext?
    
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
