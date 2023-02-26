import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    var readContext: NSManagedObjectContext { get }
    var writeContext: NSManagedObjectContext { get }
    func loadStores()
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    private static var privateShared: CoreDataManager?
    
    class var shared: CoreDataManager {
        if privateShared == nil {
            privateShared = CoreDataManager()
        }
        return privateShared!
    }
    
    let persistantContainer: NSPersistentContainer = NSPersistentContainer(name: "Operation")
    
    var readContext: NSManagedObjectContext {
        persistantContainer.viewContext
    }
    
    var writeContext: NSManagedObjectContext {
        persistantContainer.newBackgroundContext()
    }
    
    func loadStores() {
        persistantContainer.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("Error: \(error)")
            }
        }
    }
    
    private init() {}
}
