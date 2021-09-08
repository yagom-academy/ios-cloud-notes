//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    // MARK: Property
    private let memo = SampleMemo.setupSampleMemo()
    private var dataSource: UITableViewDiffableDataSource<Section, Memo>?
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        configureNavigationBar()
        configureTableView()
        registerTableViewCell()
        makeTableViewDiffableDataSource()
        snapshots(ofMemo: memo)
    }
}

// MARK: - NameSpace
extension MemoListTableViewController {
    private enum NameSpace {
        enum TableView {
            static let heightSize: CGFloat = 80
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
                                                            action: #selector(addTabButton))
    }
    
    @objc func addTabButton() {
        
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
        let detailVC = MemoDetailViewController()
        detailVC.showContents(of: memo[indexPath.row])
        
        if UITraitCollection.current.horizontalSizeClass == .regular {
            self.showDetailViewController(detailVC, sender: nil)
        } else {
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}

// MARK: - Data Source
extension MemoListTableViewController {
    private enum Section {
        case main
    }
    
    private func makeTableViewDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Memo>(tableView: tableView) { tableView, indexPath, memo in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else { fatalError() }
            
            cell.accessoryType = .disclosureIndicator
            cell.configure(with: memo)
            
            return cell
        }
    }
    
    private func snapshots(ofMemo memo: [Memo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Memo>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(memo)
        DispatchQueue.global().async { [weak self] in
            self?.dataSource?.apply(snapShot, animatingDifferences: true, completion: nil)
        }
    }
}
