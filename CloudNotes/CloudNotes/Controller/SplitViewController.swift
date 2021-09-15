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
    private var coreDataMemo: CoreDataCloudMemo?
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupChildViewControllers()
        setupSplitViewDisplayMode()
        makeTableViewDiffableDataSource()
        setupMemoCoreData()
        setupDiffableDataSource()
        configureFetchedControllerDelegate()
        coreDataMemo?.performFetch()
    }
}

extension SplitViewController {
    private func setupMemoCoreData() {
        coreDataMemo = CoreDataCloudMemo(persistentStoreDescripntion: nil)
    }
    
    private func setupDiffableDataSource() {
        dataSource?.configure(coreDataMemo: coreDataMemo)
    }
    
    private  func configureFetchedControllerDelegate() {
        guard let delegate = dataSource else { return }
        coreDataMemo?.configureFetchedControllerDelegate(delegate: delegate)
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
    
    private func showDeleteAlert(atItem indexPath: IndexPath) {
        let cancel = UIAlertAction.generateUIAlertAction(kindOf: .cancel, alertStyle: .cancel, completionHandler: nil)
        
        let deleteAction = UIAlertAction.generateUIAlertAction(kindOf: .delete, alertStyle: .destructive) { [weak self] _ in
            self?.viewController(for: .primary)?.navigationController?.popViewController(animated: true)
            self?.viewController(for: .secondary)?.view.isHidden = true
            let currentItem = self?.coreDataMemo?.getCloudMemo(at: indexPath)
            self?.coreDataMemo?.deleteObject(currentItem)
        }
        
        let alert = UIAlertController.generateAlertController(title: NameSpace.UIAlertMessage.titleMessage, message: NameSpace.UIAlertMessage.bodyMessage, style: .alert, alertActions: [cancel, deleteAction])
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showShareScreen(shareItem: CloudMemo?) {
        let activityViewController = UIActivityViewController(activityItems: [shareItem?.title, shareItem?.body], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.midX, y: view.frame.maxY, width: .zero, height: .zero)
        present(activityViewController, animated: true, completion: nil)
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
        self.viewController(for: .secondary)?.view.isHidden = false
        let currentObject = coreDataMemo?.getCloudMemo(at: indexPath)
        memoDetailViewController.configureMemoContents(title: currentObject?.title,
                                                       body: currentObject?.body,
                                                       lastModifier: currentObject?.lastModified,
                                                       indexPath: indexPath)
        show(.secondary)
    }
    
    func didTapAddButton() {
        let composeViewController = ComposeTextViewController()
        composeViewController.delegate = self
        present(UINavigationController(rootViewController: composeViewController), animated: true, completion: nil)
    }
    
    func didTapDeleteButton(at indexPath: IndexPath) {
        let currentObject = coreDataMemo?.getCloudMemo(at: indexPath)
        coreDataMemo?.deleteObject(currentObject)
        self.viewController(for: .secondary)?.view.isHidden = true
    }
    
    func didTapShareButton(at indexPath: IndexPath) {
        showShareScreen(shareItem: coreDataMemo?.getCloudMemo(at: indexPath))
    }
}

// MARK: - ComposeTextViewController Delegate
extension SplitViewController: ComposeTextViewControllerDelegate {
    func didTapSaveButton(_ text: String) {
        let texts = separateText(text)
        coreDataMemo?.createNewMemo(title: texts.title,
                                    body: texts.body,
                                    lastModifier: Date())
    }
}

// MARK: - MemoDetailViewController Delegate
extension SplitViewController: MemoDetailViewControllerDelegate {
    func contentsDidChanged(at indexPath: IndexPath, contetnsText: (title: String?, body: String?)) {
        let currentMemo = coreDataMemo?.getCloudMemo(at: indexPath)
        currentMemo?.title = contetnsText.title
        currentMemo?.body = contetnsText.body
    }
    
    func didTapSeeMoreButton(sender: UIBarButtonItem, at indexPath: IndexPath) {
        let cancelAction = UIAlertAction.generateUIAlertAction(kindOf: .cancel, alertStyle: .cancel, completionHandler: nil)
        let shareAction = UIAlertAction.generateUIAlertAction(kindOf: .share, alertStyle: .default) { [weak self] _ in
            self?.showShareScreen(shareItem: self?.coreDataMemo?.getCloudMemo(at: indexPath))
        }
        let deleteAction = UIAlertAction.generateUIAlertAction(kindOf: .delete, alertStyle: .destructive) {  [weak self] _ in
            self?.showDeleteAlert(atItem: indexPath)
        }
        
        let alertController = UIAlertController.generateAlertController(title: nil, message: nil, style: .actionSheet, alertActions: [cancelAction, shareAction, deleteAction])
        
        alertController.popoverPresentationController?.barButtonItem = sender
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Diffable DataSource
extension SplitViewController {
    private func makeTableViewDiffableDataSource() {
        dataSource = MemoListDiffableDataSource(tableView: memoListViewController.tableView) { tableView, indexPath, memo in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else {
                return MemoListTableViewCell()
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(title: memo.title, body: memo.body, lastModifier: memo.lastModified)
            
            return cell
        }
    }
}
