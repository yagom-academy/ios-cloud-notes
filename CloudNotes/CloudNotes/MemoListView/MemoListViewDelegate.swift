//
//  MemoListViewDelegate.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/03.
//

import UIKit

class MemoListViewDelegate: NSObject, UITableViewDelegate {
    private weak var owner: MemoListViewController?

    init(owner: MemoListViewController) {
        self.owner = owner
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let myCell = tableView.cellForRow(at: indexPath) as? MemoListViewCell,
              let data = myCell.data else {
            return
        }

        owner?.showDetailViewController(with: data)
    }
}
