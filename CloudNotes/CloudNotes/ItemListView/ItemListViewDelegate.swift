//
//  ItemListViewDelegate.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/03.
//

import UIKit

class ItemListViewDelegate: NSObject, UITableViewDelegate {
    weak var owner: ItemListView?

    init(owner: ItemListView) {
        self.owner = owner
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let myCell = tableView.cellForRow(at: indexPath) as? ItemListViewCell else {
            return
        }

        owner?.showDetailViewController(with: myCell.data!)
    }
}
