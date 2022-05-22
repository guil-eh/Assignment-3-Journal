//
// Assignment 3 - App Dev IOS UTS
// Matthew Parker
// Brendan Poor
// Matthew Gayoso
//

import Foundation
import CoreData

class CDirector {
    
    static let shared = CDirector()
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    } ()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JournalEntry")
        
        container.loadPersistentStores() { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Error")
            }
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true
        }
        return container
    } ()
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            }
            catch {
                fatalError("Error")
            }
        }
    }
}
