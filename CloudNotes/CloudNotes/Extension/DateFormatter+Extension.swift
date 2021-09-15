//
//  DateFormattable.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import Foundation

extension DateFormatter {
    func formatToCurrent(lastModified date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = .long
        
        return dateFormatter.string(from: date)
    }
}
