//
//  PrimaryTableViewController.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

class PrimaryTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource

extension PrimaryTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
