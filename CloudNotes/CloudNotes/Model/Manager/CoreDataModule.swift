//
//  CoreDataModule.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/14.
//

import Foundation
import CoreData

struct CoreDataModule {
    static let basicContainerName = "CloudNotes"
    static let basicEntityName = "Note"
    private var persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(containerName: String = basicContainerName, completionHandler: @escaping (Error?) -> Void) {
        persistentContainer = NSPersistentCloudKitContainer(name: containerName)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }
}
