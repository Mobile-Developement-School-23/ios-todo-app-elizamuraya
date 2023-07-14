import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    // MARK: – CoreData
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Entity")
            container.loadPersistentStores { description, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    print("DB url: ", description.url?.absoluteString)
                }
            }
            return container
        }()
        
    
        func saveContext() {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    
}

