//
//  DateFormatter.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/14.
//

import Foundation

extension Int {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        let usersLocale = Locale.current

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = usersLocale

        let date = Date(timeIntervalSince1970: Double(self))

        return dateFormatter.string(from: date)
    }
}

extension Int64 {
    func changeDateFormat() -> String {
        let dateFormatter = DateFormatter()
        let usersLocale = Locale.current

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = usersLocale

        let date = Date(timeIntervalSince1970: Double(self))

        return dateFormatter.string(from: date)
    }
}
