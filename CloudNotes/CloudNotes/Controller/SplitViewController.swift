//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class SplitViewController: UISplitViewController, TextSeparatable {
    // MARK: Property
    private let memoListViewController = MemoListTableViewController()
    private let memoDetailViewController = MemoDetailViewController()
    private var dataSource: MemoListDiffableDataSource?
    
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupChildViewControllers()
        setupSplitViewDisplayMode()
        makeTableViewDiffableDataSource()
        CoreDataCloudMemo.shared.perforFetchCloudMemo()
    }
    
}

// MARK: - Method And NameSapce
extension SplitViewController {
    enum NameSpace {
        enum UIAlertMessage {
            static let titleMessage = "진짜요?"
            static let bodyMessage = "정말로 삭제하시겠어요????"
        }
    }
    
    private func showDeleteAlert(at indexPath: IndexPath) {
        let cancel = UIAlertAction.generateUIAlertAction(kind: .cancel, alertStyle: .cancel, completionHandler: nil)
        
        let deleteAction = UIAlertAction.generateUIAlertAction(kind: .delete, alertStyle: .destructive) { [weak self] _ in
            self?.viewController(for: .primary)?.navigationController?.popViewController(animated: true)
            let currentItem = CoreDataCloudMemo.shared.getCloudMemo(at: indexPath)
            CoreDataCloudMemo.shared.deleteItem(object: currentItem)
        }
        
        let alert = UIAlertController.generateAlertController(title: NameSpace.UIAlertMessage.titleMessage, message: NameSpace.UIAlertMessage.bodyMessage, style: .alert, alertActions: [cancel, deleteAction])
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - SplitView Setup
extension SplitViewController {
    private func setupChildViewControllers() {
        memoListViewController.delegate = self
        memoDetailViewController.delegate = self
        setViewController(memoListViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
    }
    
    private func setupSplitViewDisplayMode() {
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
    
    func didTapSeeMoreButton(at indexPath: IndexPath) {
        let cancelAction = UIAlertAction.generateUIAlertAction(kind: .cancel, alertStyle: .cancel, completionHandler: nil)
        let shareAction = UIAlertAction.generateUIAlertAction(kind: .share, alertStyle: .default, completionHandler: nil)
        let deleteAction = UIAlertAction.generateUIAlertAction(kind: .delete, alertStyle: .destructive) {  [weak self] _ in
            self?.showDeleteAlert(at: indexPath)
        }

        let alertController = UIAlertController.generateAlertController(title: nil, message: nil, style: .actionSheet, alertActions: [cancelAction, shareAction, deleteAction])
        
        present(alertController, animated: true, completion: nil)
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
