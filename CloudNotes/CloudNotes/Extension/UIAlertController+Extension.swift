//
//  UIAlertController+Extension.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/12.
//

import UIKit.UIAlertController

extension UIAlertController {
    static func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [UIAlertAction], animated: Bool, completionHandler: (()->Void)? = nil, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            alert.addAction(action)
        }
        viewController.present(alert, animated: animated, completion: completionHandler)
    }
}

