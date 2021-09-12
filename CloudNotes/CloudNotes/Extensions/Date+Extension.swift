//
//  Date+Extension.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/09.
//

import Foundation

protocol Formattable {
    var formatter: DateFormatter { get }
}

extension Formattable {
    var formatter: DateFormatter {
        let dateFommatter = DateFormatter()
        dateFommatter.locale = Locale(identifier: "ko_KR")
        dateFommatter.dateStyle = .medium
        return dateFommatter
    }
}

extension Date: Formattable {
    func transformFormattedType() -> String? {
        return formatter.string(for: self)
    }
}
