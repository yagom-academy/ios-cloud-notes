//
//  TextViewDelegate.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/06.
//

import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {
    private var indexPath: IndexPath?
    private var tableView: UITableView?
    var holder: TableViewIdexPathHolder?
    
    func textViewDidChange(_ textView: UITextView) {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let myInt = Int(timeInterval)
        indexPath = holder?.indexPath
        tableView = holder?.tableView
        
        MemoData.list?[indexPath?.row ?? .zero ].lastModified = myInt
        tableView?.reloadData()
    }
}
