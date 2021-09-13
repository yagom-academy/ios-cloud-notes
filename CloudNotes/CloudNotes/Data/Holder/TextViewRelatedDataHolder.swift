//
//  MemoDataTransfer.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/09.
//

import UIKit

struct TextViewRelatedDataHolder {
    var indexPath: IndexPath?
    var tableView: UITableView?
    var textViewText : String?
    
    init(indexPath: IndexPath?, tableView: UITableView?, textViewText: String?) {
        self.indexPath = indexPath
        self.tableView = tableView
        
        if textViewText?.elementsEqual("\n") == true {
            self.textViewText = nil
        } else {
            self.textViewText = textViewText
        }
    }
}
