import Foundation

public enum FileCacheError: Error {
    case unparsableData
    case cantFindSystemDirectory
}

public final class FileCache {
    private(set) var items: [String: TodoItem] = [:]
    public func add(_ item: TodoItem) {
        items[item.id] = item
    }
    @discardableResult
    public func remove(_ id: String) -> TodoItem? {
        let item = items[id]
        items[id] = nil
        return item
    }
    // MARK: - JSON
    public func saveTaskJSON(toFile file: String) throws {
        let items = items.map { $0.value }
        try? saveTaskJSON(items: items, to: file)
    }
    public func saveTaskJSON(items: [TodoItem], to file: String) throws {
        let filemanager = FileManager.default
        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw FileCacheError.cantFindSystemDirectory }
        let path = dir.appendingPathComponent("\(file).json")
        let items = items.map { $0.json }
        let data = try JSONSerialization.data(withJSONObject: items, options: [.prettyPrinted])
        try data.write(to: path, options: [.atomicWrite])
    }
    public func loadJSON(from file: String) throws {
        self.items = try loadJSON(from: file).reduce(into: [:]) { res, item in
            res[item.id] = item
        }
    }

    public func getAll() -> [TodoItem] {
        var result: [TodoItem] = []
        result = items.values.sorted(by: { $0.dateCreated < $1.dateCreated })
        return result
    }
    public func delete(id: String) {
        for (key, value) in items {
            if value.id == id {
                items[key] = nil
            }
        }
        try? saveTaskJSON(toFile: "todoItems")
    }
    public func loadJSON(from file: String) throws -> [TodoItem] {
        let filemanager = FileManager.default
        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.cantFindSystemDirectory
        }
        let path = dir.appendingPathComponent("\(file).json")
        let data = try Data(contentsOf: path)
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let json = json as? [Any] else {
            throw FileCacheError.unparsableData
        }
        let deserializedItems = json.compactMap { TodoItem.parse(json: $0) }
        return deserializedItems
    }
    // MARK: - CSV
    public func loadCSV(from file: String) throws {
        self.items = try loadCSV(from: file).reduce(into: [:]) { res, item in
            res[item.id] = item
        }
    }
    public func loadCSV(from file: String) throws -> [TodoItem] {
        let filemanager = FileManager.default
        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.cantFindSystemDirectory
        }
        let path = dir.appendingPathComponent("\(file).csv")
        let data = try Data(contentsOf: path)
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw FileCacheError.unparsableData
        }
        let lines = csvString.components(separatedBy: "\n")
        let deserializedItems = lines.compactMap { TodoItem.parse(csv: $0) }
        return deserializedItems
    }
    public func saveCSV(to file: String) throws {
        let items = items.map { $0.value }
        try saveCSV(items: items, to: file)
    }
    public func saveCSV(items: [TodoItem], to file: String) throws {
        let filemanager = FileManager.default
        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheError.cantFindSystemDirectory
        }
        let path = dir.appendingPathComponent("\(file).csv")
        let serializedItems = items.filter { $0.importance != .normal }.map { $0.csv }
        let csvString = serializedItems.joined(separator: "\n")
        let data = csvString.data(using: .utf8)
        try data?.write(to: path)
    }
}

