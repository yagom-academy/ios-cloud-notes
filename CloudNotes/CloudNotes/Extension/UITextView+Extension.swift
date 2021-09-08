//
//  UITextView+Extension.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/08.
//

import UIKit

extension UITextView {
    private var texts: [String]? {
        return self.text.components(separatedBy: String.lineBreak)
    }
    
    private var bodyStartIndex: Int {
        return texts?[1].isEmpty == false ? 1 : 2
    }
    
    var title: String? {
        return texts?.first
    }
    
    var body: String? {
        return texts?[bodyStartIndex...].joined(separator: String.lineBreak)
    }
}
