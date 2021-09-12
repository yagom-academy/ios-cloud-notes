//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController, TextSeparatable {
    // MARK: Property
    private let memoListViewController = MemoListTableViewController()
    private let memoDetailViewController = MemoDetailViewController()
    private var dataSource: MemoListDiffableDataSource?
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupChildViewController()
        setupSplitViewDisPlayMode()
        makeTableViewDiffableDataSource()
        CoreDataCloudMemo.shared.perforFetchCloudMemo()
    }
    
}

// MARK: - SplitView Setup
extension SplitViewController {
    private func setupChildViewController() {
        memoListViewController.delegate = self
        memoDetailViewController.delegate = self
        setViewController(memoListViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
    }
    
    private func setupSplitViewDisPlayMode() {
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
}

// MARK: - SplitViewController Delegate
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

// MARK: - MemoList Delegate
extension SplitViewController: MemoListDelegate {
    func didTapTableViewCell(at indexPath: IndexPath) {
        let currentObject = CoreDataCloudMemo.shared.fetchedController.object(at: indexPath)
        memoDetailViewController.configureMemoContents(title: currentObject.title,
                                                       body: currentObject.body,
                                                       lastModifier: currentObject.lastModified,
                                                       indexPath: indexPath)
        show(.secondary)
    }
    
    func didTapAddButton() {
        let composeViewController = ComposeTextViewController()
        composeViewController.delegate = self
        present(UINavigationController(rootViewController: composeViewController), animated: true, completion: nil)
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        let currentObject = CoreDataCloudMemo.shared.fetchedController.object(at: indexPath)
        CoreDataCloudMemo.shared.deleteItem(object: currentObject)
    }
}

// MARK: - ComposeTextViewController Delegate
extension SplitViewController: ComposeTextViewControllerDelegate {
    func didTapSaveButton(_ text: String) {
        let texts = separateText(text)
        CoreDataCloudMemo.shared.createNewMemo(title: texts.title,
                                               body: texts.body,
                                               lastModifier: Date())
    }
}

// MARK: - MemoDetailViewController Delegate
extension SplitViewController: MemoDetailViewControllerDelegate {
    func contentsDidChanged(at indexPath: IndexPath, contetnsText: (title: String?, body: String?)) {
        let currentMemo = CoreDataCloudMemo.shared.getCloudMemo(at: indexPath)
        currentMemo.title = contetnsText.title
        currentMemo.body = contetnsText.body
    }
}

// MARK: - Diffable DataSource
extension SplitViewController {
    private func makeTableViewDiffableDataSource() {
        dataSource = MemoListDiffableDataSource(tableView: memoListViewController.tableView) { tableView, indexPath, memo in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else { fatalError() }
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(title: memo.title, body: memo.body, lastModifier: memo.lastModified)
            
            return cell
        }
    }
}
