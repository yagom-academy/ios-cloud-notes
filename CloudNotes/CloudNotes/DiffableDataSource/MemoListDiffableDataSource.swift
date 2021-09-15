//
//  MemoListDiffableDataSource.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit
import CoreData

final class MemoListDiffableDataSource: UITableViewDiffableDataSource<String, CloudMemo> {
    // MARK: Property
    private var coreDataMemo: CoreDataCloudMemo?
    
    // MARK: View LifeCycle
    override init(tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<String, CloudMemo>.CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
// MARK: - Method
extension MemoListDiffableDataSource {
    func configure(coreDataMemo: CoreDataCloudMemo?) {
        self.coreDataMemo = coreDataMemo
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension MemoListDiffableDataSource: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapshot = NSDiffableDataSourceSnapshot<String, CloudMemo>()
        
        snapshot.sectionIdentifiers.forEach { section in
            guard let section = section as? String else { return }
            
            newSnapshot.appendSections([section])
            
            let memos = snapshot.itemIdentifiersInSection(withIdentifier: section).compactMap { objectID -> CloudMemo? in
                guard let objectID = objectID as? NSManagedObjectID else { return nil }
                
                guard let cloudMemo =  coreDataMemo?.context.object(with: objectID) as? CloudMemo else { return nil }
                
                return cloudMemo
            }
            newSnapshot.appendItems(memos, toSection: section)
            newSnapshot.reloadItems(memos)
        }
        DispatchQueue.global().async { [weak self] in
            self?.apply(newSnapshot, animatingDifferences: true) {
                self?.coreDataMemo?.contextSave()
            }
        }
    }
}
