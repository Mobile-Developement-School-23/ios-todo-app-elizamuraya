//
//  CoreData Manager.swift
//  toDoList
//
//  Created by MacBookAir on 12.07.2023.
//
//
//import Foundation
//import CoreData

//class PersistentContainer: NSPersistentContainer {
//
////    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
////        let context = backgroundContext ?? viewContext
////        guard context.hasChanges else { return }
////        do {
////            try context.save()
////        } catch let error as NSError {
////            print("Error: \(error), \(error.userInfo)")
////        }
////    }
//}


//var persistentContainer: NSPersistentContainer = {
//       let container = NSPersistentContainer(name: "CoreData")
//       container.loadPersistentStores(completionHandler: { (_, error) in
//           if let error = error as NSError? {
//               fatalError("Failed to load Core Data stack: \(error), \(error.userInfo)")
//           }
//       })
//       return container
//   }()
//
//func saveContext() {
//    let context = persistentContainer.viewContext
//    if context.hasChanges {
//        do {
//            try context.save()
//        } catch {
//            let error = error as? NSError
//            fatalError(error?.localizedDescription)
//        }
//    }
//}
//
//public final class CoreDataManager: NSObject {
//    public static let shared = CoreDataManager()
//    private override init() {}
//
//    private var appDelegate: AppDelegate {
//        UIApplication.shared.delegate as! AppDelegate
//    }
//
//    private var context: NSManagedObjectContext {
//        appDelegate.persistentContainer.viewContext
//    }
//}
