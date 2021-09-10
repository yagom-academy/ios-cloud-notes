//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit
import CoreData

class MemoListTableViewController: UITableViewController {
    // MARK: Property
    private var dataSource: MemoListDiffableDataSource?
    weak var delegate: MemoListDelegate?
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        CoreDataCloudMemo.shared.fetchedController.delegate = self
        configureNavigationBar()
        configureTableView()
        registerTableViewCell()
        makeTableViewDiffableDataSource()
        CoreDataCloudMemo.shared.fetchCloudMemo()
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
                                              title: NameSpace.TableView.deleteText) { _, _, _ in
            
            let currentObject = CoreDataCloudMemo.shared.fetchedController.object(at: indexPath)
            CoreDataCloudMemo.shared.deleteItem(object: currentObject)
        }
        
        let shareAction = UIContextualAction(style: .normal,
                                             title: NameSpace.TableView.shareText) { _, _, _ in
            
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension MemoListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        var newSnapshot = NSDiffableDataSourceSnapshot<String, CloudMemo>()
        
        snapshot.sectionIdentifiers.forEach { section in
            guard let section = section as? String else { return }
            
            newSnapshot.appendSections([section])
            
            let items = snapshot.itemIdentifiersInSection(withIdentifier: section).compactMap { objectID -> CloudMemo? in
                guard let objectID = objectID as? NSManagedObjectID else { return nil }
                
                guard let item =  CoreDataCloudMemo.shared.fetchedController.managedObjectContext.object(with: objectID) as? CloudMemo else { return nil }
                
                return item
            }
            newSnapshot.appendItems(items, toSection: section)
            newSnapshot.reloadItems(items)
        }
        DispatchQueue.global().async { [weak self] in
            self?.dataSource?.apply(newSnapshot, animatingDifferences: true) {
                CoreDataCloudMemo.shared.contextSave()
            }
        }
    }
}

// MARK: - Data Source
extension MemoListTableViewController {
    private func makeTableViewDiffableDataSource() {
        dataSource = MemoListDiffableDataSource(tableView: tableView) { tableView, indexPath, memo in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else { fatalError() }
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: memo)
            
            return cell
        }
    }
}
