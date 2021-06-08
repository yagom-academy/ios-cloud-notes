//
//  MemoManager.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/08.
//

import UIKit
import CoreData

class MemoManager {
    static let shared = MemoManager()

    var memos: [Memo]?
    weak var memoListViewDelegate: MemoListViewDelegate?
    weak var memoDetailViewDelegate: MemoDetailViewDelegate?
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    private init() {
        fetchData()
    }

    private func fetchData() {
        do {
            let request = Memo.fetchRequest() as NSFetchRequest<Memo>
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            memos = try context?.fetch(request)
        } catch {
            return // TODO: Error Handling
        }
    }

    func createMemo() {
        guard let context = context else { return }
        let newMemo = Memo(context: context)
        newMemo.date = Date()

        let newIndexPath = IndexPath(row: 0, section: 0)

        try? context.save()
        fetchData()

        memoListViewDelegate?.createNewCell()
        memoDetailViewDelegate?.setUpData(memo: newMemo, indexPath: newIndexPath)
    }

    func updateTitle(indexPath: IndexPath, title: String) {
        guard let memos = memos,
              let context = context else { return }
        memos[indexPath.row].title = title
        memos[indexPath.row].date = Date()

        do {
            try context.save()
        } catch {
            // TODO: Error Handling
        }

        memoListViewDelegate?.updateCell(indexPath: indexPath)
    }

    func updateDescription(indexPath: IndexPath, description: String) {
        guard let memos = memos,
              let context = context else { return }
        memos[indexPath.row].memoDescription = description
        memos[indexPath.row].date = Date()

        do {
            try context.save()
        } catch {
            // TODO: Error Handling
        }

        memoListViewDelegate?.updateCell(indexPath: indexPath)
    }

    func deleteMemo(indexPath: IndexPath) {
        guard let memos = memos,
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }

        context.delete(memos[indexPath.row])
        fetchData()
        do {
            try context.save()
        } catch {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "메모 저장에 실패했어요 😢",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        }

        memoListViewDelegate?.deleteCell(indexPath: indexPath)
        memoDetailViewDelegate?.clearField()
    }
}
