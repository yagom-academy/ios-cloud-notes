//
//  TextViewDelegate.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/06.
//

import UIKit

class TextViewDelegate: NSObject, UITextViewDelegate {
    var indexPath: IndexPath?
    var tableView: UITableView?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let myInt = Int(timeInterval)
        
        MemoDataHolder.list?[indexPath?.row ?? .zero ].lastModified = myInt
       // tableView?.reloadData()
    }
}
