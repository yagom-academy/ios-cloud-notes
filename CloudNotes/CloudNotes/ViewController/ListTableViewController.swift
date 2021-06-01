//
//  ListTableViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class ListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 아이패드에서는 잘 나오는데 아이폰에서는 안나옴.
//        self.navigationController?.navigationBar.topItem?.title = "메모"
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTouched(_:)))

//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 70
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    @objc func addBarButtonTouched(_ sender: UIBarButtonItem) {
        self.splitViewController?.showDetailViewController(TextViewController(), sender: nil)
        print("done!")
        
    }
}

extension ListTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
//
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        cell.titleLabel.text = "HelloWorld!123123123123121241231312312"
        cell.dateLabel.text = "2021. 05. 31."
        cell.bodyLabel.text = "This is What I want to do!!!!!!!!!!123124123"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}
