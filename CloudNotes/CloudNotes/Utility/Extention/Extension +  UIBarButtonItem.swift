//
//  Extension +  UIBarButtonItem.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import UIKit

extension UIBarButtonItem {
    static func generateBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(systemItem: barButtonSystemItem)
        return barButtonItem
    }
}
