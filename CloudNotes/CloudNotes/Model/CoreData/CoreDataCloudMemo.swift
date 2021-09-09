//
//  CoreDataCloudeMemo.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//

import CoreData
import UIKit

final class CoreDataCloudMemo {
    static let shared = CoreDataCloudMemo()
    var fetchedController: NSFetchedResultsController<CloudMemo>
    
    private init() {
        let request: NSFetchRequest<CloudMemo> = CloudMemo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CloudMemo.lastModified),
                                                    ascending: true)]
        fetchedController = CoreDataStack.shared.makeFetchedResultsController(fetchRequest: request,
                                                                              sectionNameKeyPath:
                                                                                nil,
                                                                              cacheName: nil)
    }
    
    func contextSave() {
        guard fetchedController.managedObjectContext.hasChanges else {
            return
        }
        
        do {
            try fetchedController.managedObjectContext.save()
        } catch {
            fetchedController.managedObjectContext.rollback()
            debugPrint("저장실패")
        }
    }
    
    func createMemo(title: String?, body: String?, writeTime: Date?) {
        let newMemo = CloudMemo(context: fetchedController.managedObjectContext)
        newMemo.title = title
        newMemo.body = body
        newMemo.lastModified = writeTime
        
        fetchedController.managedObjectContext.insert(newMemo)
    }
    
    func deleteMemo(at indexPath: IndexPath) {
        let deleteMemo = fetchedController.object(at: indexPath)
        fetchedController.managedObjectContext.delete(deleteMemo)
    }
}
