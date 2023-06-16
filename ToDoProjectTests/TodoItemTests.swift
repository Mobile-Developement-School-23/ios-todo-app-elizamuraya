//
//  TodoItemTests.swift
//  ToDoProjectTests
//

import XCTest
@testable import ToDoProject


class TodoItemTests: XCTestCase {
    
    func testTodoItemInitialization() {
        let id = "1"
        let text = "Buy groceries"
        let importance = Importance.high
        let deadline = Date()
        let isCompleted = false
        let dateCreated = Date()
        let dateChanged = Date()
        
        let todoItem = TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, dateCreated: dateCreated, dateChanged: dateChanged)
        
        XCTAssertEqual(todoItem.id, id)
        XCTAssertEqual(todoItem.text, text)
        XCTAssertEqual(todoItem.importance, importance)
        XCTAssertEqual(todoItem.deadline, deadline)
        XCTAssertEqual(todoItem.isCompleted, isCompleted)
        XCTAssertEqual(todoItem.dateCreated, dateCreated)
        XCTAssertEqual(todoItem.dateChanged, dateChanged)
    }
    
    func testTodoItemJSONSerialization() {
        let id = "1"
        let text = "Buy groceries"
        let importance = Importance.high
        let deadline = Date()
        let isCompleted = false
        let dateCreated = Date()
        let dateChanged = Date()
        
        let todoItem = TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, dateCreated: dateCreated, dateChanged: dateChanged)
        
        let json = todoItem.json as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["id"] as? String, id)
        XCTAssertEqual(json?["text"] as? String, text)
        XCTAssertEqual(json?["importance"] as? String, importance.rawValue)
        XCTAssertEqual(json?["deadline"] as? Int, Int(deadline.timeIntervalSince1970))
        XCTAssertEqual(json?["isCompleted"] as? Bool, isCompleted)
        XCTAssertEqual(json?["dateCreated"] as? Int, Int(dateCreated.timeIntervalSince1970))
        XCTAssertEqual(json?["dateChanged"] as? Int, Int(dateChanged.timeIntervalSince1970))
    }
    
    func testTodoItemCSVSerialization() {
        let id = "1"
        let text = "Buy groceries"
        let importance = Importance.high
        let deadline = Date()
        let isCompleted = false
        let dateCreated = Date()
        let dateChanged = Date()
        
        let todoItem = TodoItem(id: id, text: text, importance: importance, deadline: deadline, isCompleted: isCompleted, dateCreated: dateCreated, dateChanged: dateChanged)
        
        let csv = todoItem.csv
        
        let parsedTodoItem = TodoItem.parse(csv: csv)
        
        XCTAssertNotNil(parsedTodoItem)
        XCTAssertEqual(parsedTodoItem?.id, id)
        XCTAssertEqual(parsedTodoItem?.text, text)
        XCTAssertEqual(parsedTodoItem?.importance, importance)
        XCTAssertEqual(parsedTodoItem?.deadline, deadline)
        XCTAssertEqual(parsedTodoItem?.isCompleted, isCompleted)
        XCTAssertEqual(parsedTodoItem?.dateCreated, dateCreated)
        XCTAssertEqual(parsedTodoItem?.dateChanged, dateChanged)
    }
}
