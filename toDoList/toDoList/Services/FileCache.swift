import Foundation

protocol DataCache {
    var items: [String: TodoItem] { get }
    var itemsSorted: [TodoItem] { get }
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
        defer { items[id] = nil }
        return items[id]
    }
}





//        let items = items.map { $0.value }
//
//        try? saveTaskJSON(items: items, to: file)
//    }

//    private func saveTaskJSON(items: [TodoItem], to file: String) throws {
//
//        let filemanager = FileManager.default
//
//
//        let path = dir.appendingPathComponent("\(file).json")
//        let items = items.map { $0.json }
//        let data = try JSONSerialization.data(withJSONObject: items, options: [.prettyPrinted])
//        try data.write(to: path, options: [.atomicWrite])
//    }
//




//        self.items = try loadJSON(from: file).reduce(into: [:]) { res, item in
//            res[item.id] = item
//        }


//    func getAll() -> [TodoItem] {
//
//        var result: [TodoItem] = []
//        result = items.values.sorted(by: { $0.dateCreated < $1.dateCreated })
//        return result
//    }

//    func delete(id: String) {
//
//        for (key, value) in items {
//            if value.id == id {
//                items[key] = nil
//            }
//        }
//
//        try? saveTaskJSON(toFile: "todoItems")
//    }


//    func loadJSON(from file: String) throws -> [TodoItem] {
//        let filemanager = FileManager.default
//        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            throw FileCacheError.cantFindSystemDirectory
//        }
//
//        let path = dir.appendingPathComponent("\(file).json")
//        let data = try Data(contentsOf: path)
//        let json = try JSONSerialization.jsonObject(with: data, options: [])
//        guard let json = json as? [Any] else {
//            throw FileCacheError.unparseableData
//        }
//        let deserializedItems = json.compactMap { TodoItem.parse(json: $0) }
//        return deserializedItems
//    }
//
// MARK: - CSV
//
//    func loadCSV(from file: String) throws {
//        self.items = try loadCSV(from: file).reduce(into: [:]) { res, item in
//            res[item.id] = item
//        }
//    }
//
//    func loadCSV(from file: String) throws -> [TodoItem] {
//        let filemanager = FileManager.default
//        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            throw FileCacheError.cantFindSystemDirectory
//        }
//
//        let path = dir.appendingPathComponent("\(file).csv")
//        let data = try Data(contentsOf: path)
//
//        guard let csvString = String(data: data, encoding: .utf8) else {
//            throw FileCacheError.unparseableData
//        }
//        let lines = csvString.components(separatedBy: "\n")
//        let deserializedItems = lines.compactMap { TodoItem.parse(csv: $0) }
//        return deserializedItems
//    }
//
//    func saveCSV(to file: String) throws {
//        let items = items.map { $0.value }
//        try saveCSV(items: items, to: file)
//    }
//
//    func saveCSV(items: [TodoItem], to file: String) throws {
//        let filemanager = FileManager.default
//        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            throw FileCacheError.cantFindSystemDirectory
//        }
//        let path = dir.appendingPathComponent("\(file).csv")
//        let serializedItems = items.filter { $0.importance != .normal }.map { $0.csv }
//        let csvString = serializedItems.joined(separator: "\n")
//        let data = csvString.data(using: .utf8)
//        try data?.write(to: path)
//    }
//
//}





//protocol CacheData {
//    var tasks: [String: TodoItem] { get }
//    var tasksSorted: [TodoItem] { get }
//    func add(_ task: TodoItem)
//    @discardableResult func remove(id: String) -> TodoItem?
//    func save(title: String, format: FileCache.FileCacheFormat) throws
//    func load(title: String, format: FileCache.FileCacheFormat) throws
//}
//
//final class FileCache: CacheData {
//    private(set) var tasks = [String: TodoItem]()
//    var tasksSorted: [TodoItem] {
//        tasks.sorted { $0.value.dateCreated < $1.value.dateCreated }.map { $1 }
//    }
//
//    func add(_ task: TodoItem) {
//        tasks[task.id] = task
//    }
//
//    @discardableResult
//    func remove(id: String) -> TodoItem? {
//        defer { tasks[id] = nil }
//        return tasks[id]
//    }
//
//    func save(title: String, format: FileCacheFormat) throws {
//        let dir = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        switch format {
//        case .json:
//            let url = dir.appending(path: title + ".json")
//            let tasksJSON = tasks.map(\.value.json)
//            let jsonData = try JSONSerialization.data(withJSONObject: tasksJSON, options: .prettyPrinted)
//            try jsonData.write(to: url, options: .atomic)
//        case .csv:
//            let url = dir.appending(path: title + ".csv")
//            var tasksCsv = tasks.map(\.value.csv).joined(separator: "\n")
//            //tasksCsv = TodoItem.csvHeader.joined(separator: ",") + "\n" + tasksCsv
//            try tasksCsv.write(to: url, atomically: true, encoding: .utf8)
//        }
//    }
//
//    func load(title: String, format: FileCacheFormat) throws {
//        let dir = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        var toDoItems = [TodoItem]()
//        switch format {
//        case .json:
//            let url = dir.appending(path: title + ".json")
//            let data = try Data(contentsOf: url)
//            let jsonData = try JSONSerialization.jsonObject(with: data)
//            guard let jsonArray = jsonData as? [Any] else { throw FileCacheErrors.LoadInvalidJson }
//            toDoItems = jsonArray.compactMap { TodoItem.parse(json: $0) }
//        case .csv:
//            let url = dir.appending(path: title + ".csv")
//            let data = try String(contentsOf: url).split(separator: "\n").map(String.init)
//
//        //    TodoItem = data.compactMap { TodoItem.parse(csv: $0) }
//        }
//        for toDoItem in toDoItems {
//            add(toDoItem)
//        }
//    }
//}
//
//extension FileCache {
//    enum FileCacheFormat {
//        case json
//        case csv
//    }
//
//    enum FileCacheErrors: Error {
//        case LoadInvalidJson
//    }
//}
