//
//  IntExtension.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import Foundation

extension Int {
    var stringFromUTC: String? {
        return CustomDateFormatter.utcFormatter.string(from: Date(timeIntervalSince1970: Double(self)))
    }
}
