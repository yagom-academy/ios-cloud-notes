//
//  UIView+Extensions.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/02.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
}
