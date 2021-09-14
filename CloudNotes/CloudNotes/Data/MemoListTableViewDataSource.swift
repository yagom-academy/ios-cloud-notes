//
//  MainVCTableViewDataSourceViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

final class MemoListTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoDataManager.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.defaultCell.identifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        let list = MemoDataManager.memos[indexPath.row]
        let cellContent = CellContentDataHolder(title: list.title, date: list.lastModifiedDate, body: list.body)
        cell.configure(cellContent)
        
        return cell
    }
}
