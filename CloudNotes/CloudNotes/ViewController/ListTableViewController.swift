//
//  ListTableViewController.swift
//  CloudNotes
//
//  Created by steven on 2021/05/31.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var memoList: [Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseSampleData()
        setNavigationItem()
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
    }
    
    func parseSampleData() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let jsonData = NSDataAsset(name: "sample") else {
            return
        }
        guard let memoList = try? jsonDecoder.decode([Memo].self, from: jsonData.data) else {
            return
        }
        self.memoList = memoList
    }
    
    func setNavigationItem() {
        self.navigationItem.title = "메모"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTouched(_:)))
    }
     
    @objc func addBarButtonTouched(_ sender: UIBarButtonItem) {
        self.splitViewController?.showDetailViewController(TextViewController(), sender: nil)
    }
    
}

extension ListTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let memoItem = memoList[indexPath.row]
        cell.titleLabel.text = memoItem.title
        cell.dateLabel.text = memoItem.lastModifiedDate
        cell.bodyLabel.text = memoItem.body
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailNavigationController = self.splitViewController?.viewControllers.last as? UINavigationController,
           let textViewController = detailNavigationController.topViewController as? TextViewController {
            textViewController.textView.isEditable = false
            textViewController.textView.text = memoList[indexPath.row].body
            textViewController.textView.isEditable = true
        } else {
            let textViewController = TextViewController()
            self.splitViewController?.showDetailViewController(textViewController, sender: nil)
            textViewController.textView.text = memoList[indexPath.row].body
        }
    }
}
