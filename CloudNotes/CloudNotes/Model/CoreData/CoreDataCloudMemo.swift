//
//  CoreDataCloudeMemo.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//

import CoreData
import UIKit

final class CoreDataCloudMemo: CoreDatable {
    // MARK: Property
    var context: NSManagedObjectContext
    private var fetchedController: NSFetchedResultsController<CloudMemo>
    private var coreDataStack: CoreDataStack
    
    init(persistentStoreDescripntion: NSPersistentStoreDescription? = nil) {
        coreDataStack = CoreDataStack(persistentStoreDescription: persistentStoreDescripntion)
        
        let request: NSFetchRequest<CloudMemo> = CloudMemo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CloudMemo.lastModified),
                                                    ascending: false)]
        fetchedController = coreDataStack.makeFetchedResultsController(fetchRequest: request,
                                                                       sectionNameKeyPath:
                                                                        nil,
                                                                       cacheName: nil)
        
        context = fetchedController.managedObjectContext
    }
}

// MARK: - Method
extension CoreDataCloudMemo {
    func configureFetchedControllerDelegate(delegate: NSFetchedResultsControllerDelegate) {
        fetchedController.delegate = delegate
    }
    
    func performFetch() {
        do {
            try fetchedController.performFetch()
        } catch {
            print("불러오기 실패")
        }
    }
    
    @discardableResult
    func createNewMemo(title: String?, body: String?, lastModifier: Date?) -> CloudMemo {
        let memo = CloudMemo(context: context)
        memo.title = title
        memo.body = body
        memo.lastModified = lastModifier
        
        return memo
    }
    
    func getCloudMemo(at indexPath: IndexPath) -> CloudMemo {
        return fetchedController.object(at: indexPath)
    }
}
