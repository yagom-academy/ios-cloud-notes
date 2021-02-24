//
//  IntExtension.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import Foundation

extension Date {
    var stringFromDate: String? {
        return CustomDateFormatter.utcFormatter.string(from: self)
    }
}
