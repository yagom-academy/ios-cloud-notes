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
                                                            action: #selector(addButtomTap))
    }
    
    @objc func addButtomTap() {
        
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
// MARK: - Data Source
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return memo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier,
                                                       for: indexPath) as? MemoListTableViewCell else {
            fatalError()
        }
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: memo[indexPath.row])
        
        return cell
    }
}
// MARK: - Delegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = MemoDatailViewController()
        detailVC.showContents(of: memo[indexPath.row])
        
        if UITraitCollection.current.horizontalSizeClass == .regular {
            self.showDetailViewController(UINavigationController(rootViewController: detailVC), sender: nil)
        } else {
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}
