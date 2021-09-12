//
//  CoreDataCloudeMemo.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//

import CoreData

final class CoreDataCloudMemo: CoreDatable {
    static let shared = CoreDataCloudMemo()
    var context: NSManagedObjectContext
    var fetchedController: NSFetchedResultsController<CloudMemo>
    
    private init() {
        let request: NSFetchRequest<CloudMemo> = CloudMemo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CloudMemo.lastModified),
                                                    ascending: false)]
        fetchedController = CoreDataStack.shared.makeFetchedResultsController(fetchRequest: request,
                                                                              sectionNameKeyPath:
                                                                                nil,
                                                                              cacheName: nil)
        
        context = fetchedController.managedObjectContext
    }
    
    func perforFetchCloudMemo() {
        do {
            try fetchedController.performFetch()
        } catch {
            print("불러오기 실패")
        }
    }
    
    func createNewMemo(title: String?, body: String?, lastModifier: Date?) {
        let memo = CloudMemo(context: context)
        memo.title = title
        memo.body = body
        memo.lastModified = lastModifier
    }
}
