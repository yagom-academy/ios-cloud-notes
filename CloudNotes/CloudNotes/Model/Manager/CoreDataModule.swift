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
    case failedToConvert
    
    var errorDescription: String? {
        switch self {
        case .failedToGetEntity:
            return "데이터베이스 entity 정보를 가져오지 못했습니다."
        case .failedToConvert:
            return "데이터 변환에 실패하였습니다."
        }
    }
}

struct CoreDataModule {
    //MARK: Basic Properties
    static let basicContainerName = "CloudNotes"
    static let basicEntityName = "Note"
    private let basicSortingCriterias: [NSSortDescriptor] = {
        var criterias = [NSSortDescriptor]()
        criterias.append(NSSortDescriptor(key: "lastModified", ascending: false))
        return criterias
    }()
    //MARK: Core Data Stack
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

//MARK:- CRUD
extension CoreDataModule {
    func insert(objectInfo: [String: Any],
                into entityName: String = basicEntityName,
                completionHandler: (Error?) -> Void) {
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
        } catch {
            completionHandler(error)
        }
    }
    
    func fetch<T: NSManagedObject>(predicate: NSPredicate? = nil,
                                   sortDescriptors: [NSSortDescriptor]? = nil,
                                   completionHandler: ([T]?, Error?) -> Void) {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors ?? basicSortingCriterias
        
        do {
            let fetchedDatas = try context.fetch(fetchRequest)
            if let convertedValues = fetchedDatas as? [T] {
                completionHandler(convertedValues, nil)
            } else {
                completionHandler(nil, CoreDataError.failedToConvert)
            }
        } catch {
            completionHandler(nil, error)
        }
    }
}
