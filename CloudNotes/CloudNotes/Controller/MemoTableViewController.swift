//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit
import SwiftyDropbox

class MemoTableViewController: UITableViewController {    
    private let initialIndexPath: IndexPath = .zero
    lazy var selectedIndexPath = initialIndexPath
    private weak var delegate: MemoManageable?
    
    private var isSplitViewCollapsed: Bool? {
        return self.splitViewController?.isCollapsed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellWithClass: MemoTableViewCell.self)
        configureNavigationBar()
        configureTableView()
    }
        
    init(style: UITableView.Style, delegate: MemoManageable) {
        self.delegate = delegate
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "메모"
        let addMemoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEmptyMemo))
        let connectDropboxButton = UIBarButtonItem(image: UIImage(systemName: SystemIcon.linkDropbox), style: .plain, target: self, action: nil)
        connectDropboxButton.imageInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: -15)
        
        let loginAction = UIAction(title: ActionTitle.login) { _ in
            self.connectDropbox()
        }
        
        let logoutAction = UIAction(title: ActionTitle.logout, attributes: .destructive) { _ in
            self.disconnectDropbox()
        }
        
        let connectionMenu = UIMenu(options: .displayInline, children: [loginAction, logoutAction])
        connectDropboxButton.menu = connectionMenu
        
        self.navigationItem.rightBarButtonItems = [addMemoButton, connectDropboxButton]
    }
    
    private func configureTableView() {
        if isSplitViewCollapsed == false && delegate?.isMemosEmpty == false {
            tableView.delegate?.tableView?(tableView, didSelectRowAt: initialIndexPath)
        }
        tableView.separatorInset = UIEdgeInsets.zero
    }

    @objc private func addEmptyMemo() {
        delegate?.create()
        tableView.insertRows(at: [initialIndexPath], with: .fade)
        tableView.scrollToRow(at: initialIndexPath, at: .bottom, animated: true)
        tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition: .none)
        delegate?.showSecondaryView(of: initialIndexPath)
        tableView.isEditing = false
    }
    
    private func connectDropbox() {
        delegate?.connectDropbox(viewController: self)
    }
    
    private func disconnectDropbox() {
        DropboxClientsManager.unlinkClients()
        UserDefaults.standard.set(false, forKey: UserDefaultsKey.dropboxConnected)
        delegate?.presentConnectResultAlert(type: .disconnect)
    }
    
    func updateTableView() {
        delegate?.fetchAll()
        tableView.reloadData()
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func updateSelectedIndexPath(with indexPath: IndexPath) {
        selectedIndexPath = indexPath
        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
    }
}

// MARK: - UITableViewDataSource

extension MemoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.memosCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MemoTableViewCell.self, for: indexPath)
        
        guard let data = delegate?.fetch(at: indexPath) else {
            return cell
        }
        
        cell.configureCellContent(from: data)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        delegate?.showSecondaryView(of: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            self.delegate?.delete(at: indexPath)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: SystemIcon.trash)
        deleteAction.backgroundColor = .systemRed
        
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in
            self.delegate?.presentShareActivity(at: indexPath)
            completionHandler(true)
        }
        shareAction.image = UIImage(systemName: SystemIcon.share)
        shareAction.backgroundColor = .systemIndigo
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}
