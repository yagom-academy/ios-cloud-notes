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
    var memoData: [MemoData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
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
        memoData = decodeMemoData()!
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MemoListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as! MemoListCell
        
        cell.memoTitle.text = memoData[indexPath.row].title
        cell.memoPreview.text = memoData[indexPath.row].body
        cell.memoDateCreate.text = memoData[indexPath.row].lastModifiedDate
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
}
