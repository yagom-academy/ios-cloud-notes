//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/01.
//

import UIKit

class MemoListViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: "MemoListCell")
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListCell") as? MemoListCell else {
            return MemoListCell()
        }
    
        cell.accessoryType = .disclosureIndicator
        cell.title.text = "Title"
        cell.date.text = "2021. 06. 03"
        cell.preview.text = "Preview"
        
        return cell
    }
}
