//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewController: UITableViewController {
    var characters = ["LinkLinkLinkLinkLinkLink",
                      "ZeldaZeldaZeldaZeldaZeldaZelda",
                      "GanondorfGanondorfGanondorfGanondorfGanondorf",
                      "Midna"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: "MemoTableViewCell")
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - Table view data source
extension MemoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "MemoTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
            as? MemoTableViewCell {
            cell.titleLabel.text = characters[indexPath.row]
            cell.dateLabel.text = characters[indexPath.row]
            cell.previewLabel.text = characters[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
