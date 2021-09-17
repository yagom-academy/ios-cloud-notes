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
    case failedToUpdate
    case failedToDelete
    
    var errorDescription: String? {
        switch self {
        case .failedToGetEntity:
            return "데이터베이스 entity 정보를 가져오지 못했습니다."
        case .failedToConvert:
            return "데이터 변환에 실패하였습니다."
        case .failedToUpdate:
            return "업데이트에 실패하였습니다."
        case .failedToDelete:
            return "삭제에 실패하였습니다."
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
    func insert(about objectInfo: [String: Any],
                into entityName: String = basicEntityName,
                completionHandler: (NSManagedObject?, Error?) -> Void) {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            completionHandler(nil, CoreDataError.failedToGetEntity)
            return
        }
        let item = NSManagedObject(entity: entity, insertInto: context)
        
        for (key, value) in objectInfo {
            item.setValue(value, forKey: key)
        }
        do {
            try context.save()
            completionHandler(item, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func fetch<T: NSManagedObject>(filteredBy predicate: NSPredicate? = nil,
                                   sortedBy sortDescriptors: [NSSortDescriptor]? = nil,
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
    
    func update<T: NSManagedObject>(objectType: T.Type,
                                    searchedBy predicate: NSPredicate,
                                    changeTo objectInfo: [String: Any],
                                    completionHandler: (Error?) -> Void) {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let fetchedDatas = try context.fetch(fetchRequest)
            guard isOnlyOneData(in: fetchedDatas), let targetData = fetchedDatas.first as? NSManagedObject else{
                throw CoreDataError.failedToUpdate
            }
            
            for (key, value) in objectInfo {
                targetData.setValue(value, forKey: key)
            }
            try context.save()
        } catch  {
            completionHandler(error)
        }
    }
    
    func delete<T: NSManagedObject>(objectType: T.Type,
                                    searchedBy predicate: NSPredicate,
                                    completionHandler: (Error?) -> Void) {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let fetchedDatas = try context.fetch(fetchRequest)
            guard isOnlyOneData(in: fetchedDatas), let targetData = fetchedDatas.first as? NSManagedObject else {
                throw CoreDataError.failedToDelete
            }
            
            context.delete(targetData)
            try context.save()
        } catch {
            completionHandler(error)
        }
    }
    
    private func isOnlyOneData(in list: [Any]) -> Bool {
        return list.count == 1
    }
}
