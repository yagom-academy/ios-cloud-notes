//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewController: UITableViewController, MemoContainer {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()

    }

}

extension MemoListTableViewController {
    func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtomTap))
    }

    @objc func addButtomTap() {

    }
}

extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return memo.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = UITableViewCell()
        return cell
    }
}
