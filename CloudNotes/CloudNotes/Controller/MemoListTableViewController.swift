//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    // MARK: Property
    weak var delegate: MemoListDelegate?
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        configureNavigationBar()
        configureTableView()
        registerTableViewCell()
    }
}

// MARK: - NameSpace
extension MemoListTableViewController {
    private enum NameSpace {
        enum TableView {
            static let heightSize: CGFloat = 80
            static let deleteText = "Delete"
            static let shareText = "Share"
        }
        
        enum NavigationItem {
            static let title = "메모"
        }
    }
}

// MARK: - Configure Navigation
extension MemoListTableViewController {
    private func configureNavigationBar() {
        navigationItem.title = NameSpace.NavigationItem.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didAddButtonTap))
    }
    
    @objc func didAddButtonTap() {
        delegate?.didTapAddButton()
    }
}

// MARK: - Setup TableView
extension MemoListTableViewController {
    private func registerTableViewCell() {
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.identifier)
    }
    
    private func configureTableView() {
        tableView.rowHeight = NameSpace.TableView.heightSize
        tableView.separatorInset = UIEdgeInsets.zero
    }
}

// MARK: - Delegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapTableViewCell(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: NameSpace.TableView.deleteText) { [weak self] _, _, _ in
            
            self?.delegate?.didTapDeleteButton(at: indexPath)
        }
        
        let shareAction = UIContextualAction(style: .normal,
                                             title: NameSpace.TableView.shareText) { _, _, _ in
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
