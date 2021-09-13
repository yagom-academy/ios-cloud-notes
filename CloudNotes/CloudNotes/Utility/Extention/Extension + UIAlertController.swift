//
//  Extension + UIAlertController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/12.
//

import UIKit

extension UIAlertController {
    enum NameSpace {
        static let delete = "Delete"
        static let share = "Share..."
        static let cancel = "Cancel"
    }
    
    static func generateAlertController(title: String?, message: String?, style: UIAlertController.Style, alertActions: [UIAlertAction]?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        alertActions?.forEach { alertAction in
            alert.addAction(alertAction)
        }
        
        return alert
    }
}
