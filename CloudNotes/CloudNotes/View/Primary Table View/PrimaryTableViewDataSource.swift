//
//  PrimaryTableViewDataSource.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryTableViewDataSource: NSObject {
    let testArr = [1, 2, 3, 4, 5, 6]
}

extension PrimaryTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? PrimaryTableViewCell else {
            return UITableViewCell()
        }
        
        let value = testArr[indexPath.row]
        cell.configure(title: "\(value)", detail: "\(value)", date: value)

        return cell
    }
    
}
