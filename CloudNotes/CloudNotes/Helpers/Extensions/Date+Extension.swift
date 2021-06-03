//
//  Date+Extension.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate("yyyy. MM. dd.")
        return formatter.string(from: self)
    }
}
