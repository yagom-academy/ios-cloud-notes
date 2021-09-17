//
//  CloudNotes - SplitViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreData

class SplitViewController: UISplitViewController {

    private let memoListView = MemoListViewController()
    private let memoDetailView = MemoDetailViewController()
    private let splitViewDelegator = SplitViewDelegate()
    private let coreDataManager = CoreDataManager()

    var isTest = false

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = splitViewDelegator

        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        setViewController(memoListView, for: .primary)
        setViewController(memoDetailView, for: .secondary)

        memoListView.messenger = self
        memoDetailView.messenger = self

        if let memoList = loadMemoList() {
            memoListView.insertMemoList(memoList: memoList)
        }
    }
}

// MARK: - Messenger Delegate
extension SplitViewController: MessengerBetweenController {
    func showActionSheet() {
        let share = NSLocalizedString("Share", comment: "")
        let delete = NSLocalizedString("Delete", comment: "")
        let cancel = NSLocalizedString("Cancel", comment: "")

        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        let shareAction = UIAlertAction(title: share, style: .default)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel)
        let deleteAction = UIAlertAction(title: delete, style: .destructive) { _ in
            self.deleteMemo()
            self.show(.primary)
        }

        alert.addAction(shareAction)
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: false, completion: nil)
    }

    func updateListViewController(with memo: Memo?) {
        memoListView.configure(with: memo)
    }

    func showListViewController() {
        show(.primary)
    }

    func deleteMemo() {
        memoListView.deleteMemo()
    }

    func createMemo(with memo: Memo) {
        if coreDataManager.createMemo(with: memo) {
            print("success in creating memo")
        } else {
            print("failure in creating memo")
        }
    }

    func updateMemo(_ memo: Memo, at index: Int) {
        if coreDataManager.updateMemo(with: memo, at: index) {
            print("success in updating memo")
        } else {
            print("failure in updating memo")
        }
    }

    func deleteMemo(at index: Int) {
        if coreDataManager.deleteMemo(at: index) {
            print("success in deleting memo")
        } else {
            print("failure in deleting memo")
        }
    }

    func showDetailViewController(with memo: Memo?) {
        memoDetailView.configure(with: memo)

        show(.secondary)
    }
}

// MARK: - Managing CoreData
extension SplitViewController {
    func saveContext() {
        coreDataManager.saveContext()
    }

    private func loadMemoList() -> [Memo]? {
        if isTest {
            return loadMemoListForTest()
        } else {
            do {
                return try coreDataManager.retrieveMemoList().get()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    private func loadMemoListForTest() -> [Memo]? {
        let assetName = "sampleData"

        guard let asset = NSDataAsset(name: assetName),
              let parsedAsset = try? JSONSerialization.jsonObject(
                with: asset.data,
                options: JSONSerialization.ReadingOptions()
              ) as? [[String: Any]] else {
            return nil
        }

        let memoList: [Memo] = parsedAsset.map { dictionary in
            let decodedDictionary = Parser.decode(from: dictionary, to: Memo.self)

            guard let memo = try? decodedDictionary.get() else {
                let corrupted = "Corrupted"

                return Memo(
                    title: corrupted,
                    body: corrupted,
                    lastUpdatedTime: .zero
                )
            }

            return memo
        }

        return memoList
    }
}
