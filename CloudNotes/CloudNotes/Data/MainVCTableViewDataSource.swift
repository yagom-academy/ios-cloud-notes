//
//  MainVCTableViewDataSourceViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

final class MainVCTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoDataManager.memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.defaultCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let list = MemoDataManager.memos[indexPath.row]
        let date = DateFormatter().updateLastModifiedDate(Int(list.lastModifiedDate ))
        let cellContent = CellContentDataHolder(title: list.title, date: date, body: list.body)
        cell.configure(cellContent)
        
        return cell
    }
}
