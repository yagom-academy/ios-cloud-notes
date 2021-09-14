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

    var coreDataContainer: NSPersistentContainer?
    var isTest = true

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
    func showListViewController(with data: Memo?) {
        memoListView.updateMemo(with: data)

        show(.primary)
    }

    func showDetailViewController(with data: Memo?) {
        memoDetailView.configure(with: data)

        show(.secondary)
    }
}

// MARK: - Load Data by asset
extension SplitViewController {
    private func loadMemoList() -> [Memo]? {
        if isTest {
            return loadMemoListForTest()
        } else {
            return [Memo]()
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
                    description: corrupted,
                    lastUpdatedTime: .zero
                )
            }

            return memo
        }

        return memoList
    }
}
