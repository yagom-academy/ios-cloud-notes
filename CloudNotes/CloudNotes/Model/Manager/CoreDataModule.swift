//
//  CoreDataModule.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/14.
//

import Foundation
import CoreData

enum CoreDataError: Error, LocalizedError {
    case failedToGetEntity
    var errorDescription: String? {
        switch self {
        case .failedToGetEntity:
            return "데이터베이스 entity 정보를 가져오지 못했습니다."
        }
    }
}

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
    
    func insert(objectInfo: [String : Any], into entityName: String = basicEntityName, completionHandler: (Error?) -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            completionHandler(CoreDataError.failedToGetEntity)
            return
        }
        let item = NSManagedObject(entity: entity, insertInto: context)
        
        for (key, value) in objectInfo {
            item.setValue(value, forKey: key)
        }
        do {
            try context.save()
            completionHandler(nil)
        } catch  {
            completionHandler(error)
        }
    }
}
