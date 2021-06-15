//
//  UIResponder+Extension.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/15.
//

import UIKit

extension UIResponder {
    private weak static var current: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        UIResponder.current = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder.current
    }
    
    @objc func findFirstResponder(sender: AnyObject) {
        UIResponder.current = self
    }
}
