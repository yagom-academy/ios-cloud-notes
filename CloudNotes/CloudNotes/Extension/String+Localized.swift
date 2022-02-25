//
//  String+Localized.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: .blank)
    }
}
