//
//  DateFormatter.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/16.
//

import Foundation

extension DateFormatter {
    func localizedString(from date: TimeInterval) -> String {
        self.dateStyle = .medium
        self.timeStyle = .none
        self.locale = Locale.current
        
        let convertedDate = Date(timeIntervalSince1970: date)
        return self.string(from: convertedDate)
    }
}
