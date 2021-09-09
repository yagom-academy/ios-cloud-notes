//
//  MemoDataTransfer.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/09.
//

import UIKit

class MemoDataHolder {
    var testViewText: String?
    var indexPath: IndexPath?
    var tableView: UITableView?
    
    init(testViewText: String?, indexPath: IndexPath?, tableView: UITableView?) {
        self.testViewText = testViewText
        self.indexPath = indexPath
        self.tableView = tableView
    }
}
