//
//  MemoTextVIew.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/14.
//

import UIKit

class MemoTextView: UITextView {
    
}

extension MemoTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        NotificationCenter.default.post(name: NotificationNames.update.name, object: self.text)
    }
}
