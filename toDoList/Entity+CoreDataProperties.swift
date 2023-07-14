////
////  Entity+CoreDataProperties.swift
////  toDoList
////
////  Created by MacBookAir on 13.07.2023.
////
////

import Foundation
import CoreData


public extension Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }
    @NSManaged var id: String
    @NSManaged var text: String
    @NSManaged var importance: String
    @NSManaged var deadline: Date?
    @NSManaged var isCompleted: Bool
    @NSManaged var dateCreated: Date
    @NSManaged var dateChanged: Date?
}

extension Entity : Identifiable {}
