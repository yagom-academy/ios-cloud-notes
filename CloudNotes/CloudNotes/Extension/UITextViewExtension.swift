//
//  TextViewDelegateExtension.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/18.
//

import UIKit

extension UITextView {
    func setTextViewAllDataDetectorTypes() {
        self.isEditable = false
        self.dataDetectorTypes = [.all]
    }
}
