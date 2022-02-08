//
//  ListViewController.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/07.
//

import UIKit

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 10
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        
        var content = cell.defaultContentConfiguration()
        content.text = "test \(indexPath.row)"
        cell.contentConfiguration = content
        return cell
    }
}
