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
    weak var splitViewDelegate: SplitViewDelegate?
    weak var memoListViewDelegate: MemoListViewDelegate?
    weak var memoDetailViewDelegate: MemoDetailViewDelegate?
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    private init() {
        fetchData()
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
            splitViewDelegate?.showAlert(alert: failAlert(title: "제목 저장 실패",
                                                          message: "메모의 제목을 저장하지 못했어요😢"))
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
            splitViewDelegate?.showAlert(alert: failAlert(title: "내용 저장 실패",
                                                          message: "메모의 내용을 저장하지 못했어요😢"))
        }

        memoListViewDelegate?.updateCell(indexPath: indexPath)
    }

    func deleteMemo(indexPath: IndexPath) {
        guard let memos = memos,
              let context = context else { return }

        context.delete(memos[indexPath.row])
        fetchData()
        do {
            try context.save()
        } catch {
            splitViewDelegate?.showAlert(alert: failAlert(title: "메모 삭제 실패",
                                                          message: "메모를 삭제하지 못했어요😢"))
        }

        reconfirmDeleteAlert(indexPath: indexPath)
    }

    private func reconfirmDeleteAlert(indexPath: IndexPath) {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { _ in
            self.memoListViewDelegate?.deleteCell(indexPath: indexPath)
            self.memoDetailViewDelegate?.clearField()
        }
        let noAction = UIAlertAction(title: "아니오", style: .destructive, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        splitViewDelegate?.showAlert(alert: alert)
    }

    private func failAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alert
    }

    private func fetchData() {
        do {
            let request = Memo.fetchRequest() as NSFetchRequest<Memo>
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            memos = try context?.fetch(request)
        } catch {
            splitViewDelegate?.showAlert(alert: failAlert(title: "데이터 불러오기 실패",
                                                          message: "데이터를 가져오지 못했어요😢"))
        }
    }
}
