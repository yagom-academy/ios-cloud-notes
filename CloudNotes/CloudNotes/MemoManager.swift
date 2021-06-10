//
//  MemoManager.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/08.
//

import UIKit
import CoreData

class MemoManager {
    var memos: [Memo]?
    weak var memoManagerDelegate: MemoManagerDelegate?

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer? = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                let alert = UIAlertController(title: "데이터 저장소 불러오기 오류",
                                              message: error.description,
                                              preferredStyle: .alert)
                self.memoManagerDelegate?.showAlert(alert: alert)
            }
        }
        return container
    }()

    static let shared = MemoManager()

    func createMemo() {
        guard let context = persistentContainer?.viewContext else { return }
        let newMemo = Memo(context: context)
        newMemo.date = Date()

        context.perform {
            let newMemo = Memo(context: context)
            newMemo.date = Date()

            self.memos?.insert(newMemo, at: 0)
            let newIndexPath = IndexPath(row: 0, section: 0)
            self.memoManagerDelegate?.memoDidCreated(createdMemo: newMemo, createdMemoIndexPath: newIndexPath)
        }
    }

    func updateMemoTitle(indexPath: IndexPath, text: String) {
        let memo = memos?[indexPath.row]
        memo?.date = Date()
        memo?.title = text

        memoManagerDelegate?.memoDidUpdated(updatedMemoIndexPath: indexPath)
    }

    func updateMemoDescription(indexPath: IndexPath, text: String) {
        let memo = memos?[indexPath.row]
        memo?.date = Date()
        memo?.memoDescription = text

        memoManagerDelegate?.memoDidUpdated(updatedMemoIndexPath: indexPath)
    }

    func deleteMemo(indexPath: IndexPath) {
        guard let context = persistentContainer?.viewContext,
              let memoToDelete = memos?[indexPath.row] else { return }

        context.delete(memoToDelete)
        self.memos?.remove(at: indexPath.row)
        self.memoManagerDelegate?.memoDidDeleted(deletedMemoIndexPath: indexPath)
    }

    func fetchMemoData(completionHandler: @escaping (Result<Any?, CoreDataError>) -> Void) {
        guard let context = persistentContainer?.viewContext else { return }

        DispatchQueue.global().async {
            do {
                let request = Memo.fetchRequest() as NSFetchRequest<Memo>
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

                self.memos = try context.fetch(request)
                completionHandler(.success(nil))
            } catch {
                completionHandler(.failure(.fetchFailed))
            }
        }
    }
}
