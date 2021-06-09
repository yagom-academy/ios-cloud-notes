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

    static let shared = MemoManager()

    func createMemo() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let newMemo = Memo(context: context)
        newMemo.date = Date()

        memos?.insert(newMemo, at: 0) // 시간복잡도 O(n), 적절히 수정해야함
        let newIndexPath = IndexPath(row: 0, section: 0)
        memoManagerDelegate?.memoDidCreated(createdMemo: newMemo, createdMemoIndexPath: newIndexPath)
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
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let memoToDelete = memos?[indexPath.row] else { return }
        context.delete(memoToDelete)
        self.memos?.remove(at: indexPath.row)
        self.memoManagerDelegate?.memoDidDeleted(deletedMemoIndexPath: indexPath)
    }

    func fetchMemoData() {
        do {
            let request = Memo.fetchRequest() as NSFetchRequest<Memo>
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            memos = try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(request)
        } catch {
            // throw
        }
    }
}
