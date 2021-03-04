//
//  StringExtension.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/25.
//

import Foundation

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isBlank: Bool {
        get {
            self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").isEmpty
        }
    }
    
    var isNotBlank: Bool {
        return !isBlank
    }
}
