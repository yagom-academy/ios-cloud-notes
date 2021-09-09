//
//  String+Extensions.swift
//  CloudNotes
//
//  Created by Luyan on 2021/09/03.
//

import Foundation

extension String {
    var lines: [String] { return self.components(separatedBy: NSCharacterSet.newlines)}
}
