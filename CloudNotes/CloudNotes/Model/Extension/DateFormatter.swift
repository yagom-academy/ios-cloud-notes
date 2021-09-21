//
//  DateFormatter.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/10.
//

import Foundation

extension DateFormatter {
    func updateLastModifiedDate(_ lastModifiedDate: Date) -> String {
        let customDateFormatter = customDateFormatter()
        let dateString = customDateFormatter.string(from: lastModifiedDate)
        
        return dateString
    }
    
    private func customDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        
        return formatter
    }
}
