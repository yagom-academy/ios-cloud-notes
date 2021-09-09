//
//  MemoDataTransfer.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/09.
//

import UIKit

class TableViewIdexPathHolder {
    var indexPath: IndexPath?
    var tableView: UITableView?
    
    init(indexPath: IndexPath?, tableView: UITableView?) {
        self.indexPath = indexPath
        self.tableView = tableView
    }
}

//class MemoDataHolder {
//    var data: String?
//    
//    init(data: String?) {
//        self.data = data
//    }
//}

