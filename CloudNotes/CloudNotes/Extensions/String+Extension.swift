//
//  String+Extension.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/17.
//

import Foundation

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
