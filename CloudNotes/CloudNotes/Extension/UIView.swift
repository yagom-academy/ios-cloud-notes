//
//  UIView.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/03.
//

import UIKit

extension UIView {
    func setAnchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, layoutMargins: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        top.flatMap { topAnchor.constraint(equalTo: $0, constant: layoutMargins.top).isActive = true
        }
        
        bottom.flatMap {
            bottomAnchor.constraint(equalTo: $0, constant: -layoutMargins.bottom).isActive = true
        }
        
        left.flatMap { leftAnchor.constraint(equalTo: $0, constant: layoutMargins.left).isActive = true
        }
        
        right.flatMap { rightAnchor.constraint(equalTo: $0, constant: -layoutMargins.right).isActive = true }
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
}
