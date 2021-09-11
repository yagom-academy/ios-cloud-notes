//
//  MainVCTableViewDataSourceViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

class MainVCTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrimaryViewController.memos?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.defaultCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let list = PrimaryViewController.memos?[indexPath.row]
        let date = DateFormatter().updateLastModifiedDate(Int(list?.lastModifiedDate ?? .zero))
        let cellContent = CellContentDataHolder(title: list?.title, date: date, body: list?.body)
        
        cell.configure(cellContent)
        
        return cell
    }
}
