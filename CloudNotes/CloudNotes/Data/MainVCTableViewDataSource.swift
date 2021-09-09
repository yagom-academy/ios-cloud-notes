//
//  MainVCTableViewDataSourceViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

class MainVCTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoData.list?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellID.defaultCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let list = MemoData.list?[indexPath.row]
        let date = CustomDateFormatter(lastModifiedDateInt: list?.lastModified).dateString
        let cellContent = CellContentDataHolder(title: list?.title, date: date, body: list?.body)
        
        cell.configure(cellContent)
        
        return cell
    }
}
