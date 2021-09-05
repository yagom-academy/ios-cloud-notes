//
//  MainVCTableViewDataSourceViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

class MainVCTableViewDataSource: NSObject, UITableViewDataSource {
    private let memoList = MemoDataHolder.list
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.defaultCell.description, for: indexPath) as? MainTableViewCell else { return UITableViewCell()
        }
        
        let list = memoList?[indexPath.row]
        let cellContent = CellContentDataHolder(title: list?.title, date: "2020.20.20", body: list?.body)
        cell.configure(cellContent)
        
        return cell
    }
}

