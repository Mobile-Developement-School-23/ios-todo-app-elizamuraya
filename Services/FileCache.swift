//
//  FileManager.swift
//  ToDoProject


import Foundation

enum FileCacheError: Error {
    case unparsableData
    case cantFindSystemDirectory
}

final class FileCache {
    private(set) var items: [String: TodoItem] = [:]
 
    func add(_ item: TodoItem) {
        items[item.id] = item
    }
    
    @discardableResult
    func remove(_ id: String) -> TodoItem? {
        let item = items[id]
        items[id] = nil
        return item
    }
    
    // MARK: - JSON
    
    func saveTaskJSON(toFile file: String) throws {
        let items = items.map { $0.value }
       
    }
    
    func saveTaskJSON(items: [TodoItem], to file: String) throws {
        let filemanager = FileManager.default
        guard let dir = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first else { throw FileCacheError.cantFindSystemDirectory }
        
        let path = dir.appendingPathComponent("\(file).json")
        let items = items.map { $0.json }
        let data = try JSONSerialization.data(withJSONObject: items, options: [.prettyPrinted])
        try data.write(to: path, options: [.atomicWrite])
    }
    
    func loadJSON(from file: String) throws {
        self.items = try loadJSON(from: file).reduce(into: [:]) { res, item in
            res[item.id] = item
        }
    }
    
    func loadJSON(from file: String) throws -> [TodoItem] {
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
    
    func loadCSV(from file: String) throws {
        self.items = try loadCSV(from: file).reduce(into: [:]) { res, item in
            res[item.id] = item
        }
    }
    
    func loadCSV(from file: String) throws -> [TodoItem] {
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

    func saveCSV(to file: String) throws {
        let items = items.map { $0.value }
        try saveCSV(items: items, to: file)
    }
    
    func saveCSV(items: [TodoItem], to file: String) throws {
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

