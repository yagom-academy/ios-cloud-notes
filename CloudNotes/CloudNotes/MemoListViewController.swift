//
//  MemoListViewController.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class MemoListViewController: UIViewController {
    let tableView = UITableView()
    let decoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.view.addSubview(self.tableView)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top,
                                                   multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .bottom, relatedBy: .equal, toItem: self.view,
                                                   attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .leading, relatedBy: .equal, toItem: self.view,
                                                   attribute: .leading, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView,
                                                   attribute: .trailing, relatedBy: .equal, toItem: self.view,
                                                   attribute: .trailing, multiplier: 1.0, constant: 0))
    }
    
    func decodeMemoData() -> [MemoData]? {
        guard let data = NSDataAsset(name: "sample") else { return nil }
        
        do {
            let result = try decoder.decode([MemoData].self, from: data.data)
            return result
        }
        catch {
            return nil
        }
    }
}

extension MemoListViewController: UITableViewDelegate {
    
}

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memoData = decodeMemoData()!
        
        return memoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as UITableViewCell

        let memoData = decodeMemoData()!
        
        cell.textLabel?.text = memoData[indexPath.row].title

        return cell
    }
    
}
