//
//  CoreDataCloudeMemo.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/09.
//

import CoreData
import UIKit

final class CoreDataCloudMemo: NSObject, CoreDatable {
    static let shared = CoreDataCloudMemo()
    var context: NSManagedObjectContext
    var fetchedController: NSFetchedResultsController<CloudMemo> {
        didSet {
            fetchedController.delegate = self
        }
    }
    weak var delegate: CoreDataCloudMemoDelegate?
    
    private override init() {
        let request: NSFetchRequest<CloudMemo> = CloudMemo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CloudMemo.lastModified),
                                                    ascending: true)]
        fetchedController = CoreDataStack.shared.makeFetchedResultsController(fetchRequest: request,
                                                                              sectionNameKeyPath:
                                                                                nil,
                                                                              cacheName: nil)
        
        context = fetchedController.managedObjectContext
        super.init()
    }
    
    func fetchCloudMemo() {
        do {
            try fetchedController.performFetch()
        } catch {
            print("불러오기 실패")
        }
    }
}

extension CoreDataCloudMemo: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapshot = NSDiffableDataSourceSnapshot<String, CloudMemo>()
        
        snapshot.sectionIdentifiers.forEach { section in
            guard let section = section as? String else { return }
            
            newSnapshot.appendSections([section])
            
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).compactMap { objectID -> CloudMemo? in
                guard let objectID = objectID as? NSManagedObjectID else { return nil }
                
                guard let item =  CoreDataCloudMemo.shared.fetchedController.managedObjectContext.object(with: objectID) as? CloudMemo else { return nil }
                
                return item
            }
            newSnapshot.appendItems(items, toSection: section)
        }
        delegate?.didSnapshotFinished(newSnapshot)
    }
}
