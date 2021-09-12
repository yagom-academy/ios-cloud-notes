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

extension SplitViewController: MemoListDelegate {
    func didTapTableViewCell(at indexPath: IndexPath) {
        let currentObject = CoreDataCloudMemo.shared.fetchedController.object(at: indexPath)
        memoDetailViewController.configure(currentObject)
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

extension SplitViewController: ComposeTextViewControllerDelegate {
    func didTapSaveButton(_ text: String) {
        let texts = separateText(text)
        CoreDataCloudMemo.shared.createNewMemo(title: texts.title,
                                               body: texts.body,
                                               lastModifier: Date())
    }
}

// MARK: - Diffable DataSource
extension SplitViewController {
    private func makeTableViewDiffableDataSource() {
        dataSource = MemoListDiffableDataSource(tableView: memoListViewController.tableView) { tableView, indexPath, memo in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else { fatalError() }
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: memo)
            
            return cell
        }
    }
    
}
