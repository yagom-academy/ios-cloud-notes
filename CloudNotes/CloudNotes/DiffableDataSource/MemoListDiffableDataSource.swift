//
//  MemoListDiffableDataSource.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

class MemoListDiffableDataSource: UITableViewDiffableDataSource<String, CloudMemo> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
