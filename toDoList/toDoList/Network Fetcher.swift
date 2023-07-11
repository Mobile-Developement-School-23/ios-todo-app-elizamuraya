import Foundation

final class NetworkFetcher {
    private var revision: Int?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    func getAllItems() async throws -> [TodoItem] {
        
        let url = try RequestProcessor.makeURL()
        let (data, _) = try await RequestProcessor.performRequest(with: url)
        let networkListToDoItems = try decoder.decode(ListToDoItems.self, from: data)
        revision = networkListToDoItems.revision
        return networkListToDoItems.list.map { TodoItem.convert(from: $0) }
    }
    
    func addItem(toDoItem: TodoItem) async throws {
        let elementToDoItem = ElementToDoItem(element: toDoItem.networkItem)
        let url = try RequestProcessor.makeURL()
        let httpBody = try encoder.encode(elementToDoItem)
        let (responseData, _) = try await RequestProcessor.performRequest(with: url, method: .post, revision: revision, httpBody: httpBody)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: responseData)
        revision = toDoItemNetwork.revision
    }
    
    func removeItem(id: String) async throws {
        let url = try RequestProcessor.makeURL(from: id)
        let (data, response) = try await RequestProcessor.performRequest(with: url, method: .delete, revision: revision)
        print("requestRemoveItem")
        debugPrint(response.statusCode)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: data)
        print(toDoItemNetwork)
        revision = toDoItemNetwork.revision
    }
    
    func updateAllItems() async throws {
        let url = try RequestProcessor.makeURL()
        let toDoItem = NetworkToDoItem(id: "2CEBF7A4-BB56-465F-BEE9-AA5BB350A5ED", text: "Task2", importance: "basic", deadline: 710065048, done: true, createdAt: 710065048, changedAt: 710065048, lastUpdatedBy: "iphone")
        let data = ListToDoItems(list: [toDoItem])
        let httpBody = try encoder.encode(data)
        let (responseData, response) = try await RequestProcessor.performRequest(with: url, method: .patch, revision: revision, httpBody: httpBody)
        print("requestUpdateItems")
        debugPrint(response.statusCode)
        let toDoItemNetwork = try decoder.decode(ListToDoItems.self, from: responseData)
        print(toDoItemNetwork)
        revision = toDoItemNetwork.revision
    }
    
    func getItem(id: String) async throws {
        let url = try RequestProcessor.makeURL(from: id)
        let (data, response) = try await RequestProcessor.performRequest(with: url)
        print("requestGetItem")
        debugPrint(response.statusCode)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: data)
        print(toDoItemNetwork)
        revision = toDoItemNetwork.revision
    }
    
    func changeItem(id: String) async throws {
        let url = try RequestProcessor.makeURL(from: id)
        let toDoItem = NetworkToDoItem(id: id, text: "Task2", importance: "basic", deadline: 710065048, done: true, createdAt: 710065048, changedAt: 710065048, lastUpdatedBy: "iphone")
        
        let data = ElementToDoItem(element: toDoItem)
        let httpBody = try encoder.encode(data)
        let (responseData, response) = try await RequestProcessor.performRequest(with: url, method: .put, revision: revision, httpBody: httpBody)
        print("requestChangeItem")
        debugPrint(response.statusCode)
        let toDoItemNetwork = try decoder.decode(ElementToDoItem.self, from: responseData)
        print(toDoItemNetwork)
        revision = toDoItemNetwork.revision
    }
}

