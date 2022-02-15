//
//  UIViewController+Extension.swift
//  CloudNotes
//
//  Created by Siwon Kim on 2022/02/15.
//

import UIKit
extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
