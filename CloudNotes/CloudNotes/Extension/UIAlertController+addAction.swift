//
//  UIAlertController+addAction.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/15.
//

import UIKit

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}
