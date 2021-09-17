//
//  CoreDataModule.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/14.
//

import Foundation
import CoreData

enum CoreDataError: Error, LocalizedError {
    case failedToConvert
    case failedToUpdate
    case failedToDelete
    
    var errorDescription: String? {
        switch self {
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
    static let basicSortingCriterias = [NSSortDescriptor(key: "lastModified", ascending: false)]
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
    func insert<T: NSManagedObject>(about objectInfo: [String: Any],
                                    completionHandler: (T?, Error?) -> Void) {
        let item = T(context: context)
        
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
                                   sortedBy sortDescriptors: [NSSortDescriptor] = basicSortingCriterias,
                                   completionHandler: ([T]?, Error?) -> Void) {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let fetchedDatas = try context.fetch(fetchRequest)
            guard let convertedValues = fetchedDatas as? [T] else {
                throw CoreDataError.failedToConvert
            }
            completionHandler(convertedValues, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func update<T: NSManagedObject>(searchedBy predicate: NSPredicate,
                                    changeTo objectInfo: [String: Any],
                                    completionHandler: (T?, Error?) -> Void) {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let fetchedDatas = try context.fetch(fetchRequest)
            guard isOnlyOneData(in: fetchedDatas), let targetData = fetchedDatas.first as? T else{
                throw CoreDataError.failedToUpdate
            }
            
            for (key, value) in objectInfo {
                targetData.setValue(value, forKey: key)
            }
            try context.save()
            completionHandler(targetData, nil)
        } catch  {
            completionHandler(nil, error)
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
