//
//  UIView.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/03.
//

import UIKit

extension UIView {
    func setAnchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, layoutMargins: NSDirectionalEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        top.flatMap { topAnchor.constraint(equalTo: $0, constant: layoutMargins.top).isActive = true
        }
        
        bottom.flatMap {
            bottomAnchor.constraint(equalTo: $0, constant: -layoutMargins.bottom).isActive = true
        }
        
        leading.flatMap { leadingAnchor.constraint(equalTo: $0, constant: directionalLayoutMargins.leading).isActive = true
        }
        
        trailing.flatMap { trailingAnchor.constraint(equalTo: $0, constant: -directionalLayoutMargins.trailing).isActive = true }
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    func setPosition(top: NSLayoutYAxisAnchor?, topConstant: CGFloat = .zero, bottom: NSLayoutYAxisAnchor?, bottomConstant: CGFloat = .zero, leading: NSLayoutXAxisAnchor?, leadingConstant: CGFloat = .zero, trailing: NSLayoutXAxisAnchor?, trailingConstant: CGFloat = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        top.flatMap { topAnchor.constraint(equalTo: $0, constant: topConstant).isActive = true
        }
        
        bottom.flatMap {
            bottomAnchor.constraint(equalTo: $0, constant: bottomConstant).isActive = true
        }
        
        leading.flatMap { leadingAnchor.constraint(equalTo: $0, constant: leadingConstant).isActive = true
        }
        
        trailing.flatMap { trailingAnchor.constraint(equalTo: $0, constant: trailingConstant).isActive = true }
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
}
