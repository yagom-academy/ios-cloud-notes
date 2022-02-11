//
//  TimeInterval+dateString.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import Foundation

extension TimeInterval {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let devicePreferredLanguage = Locale.preferredLanguages.first ?? "ko"
        dateFormatter.locale = Locale(identifier: devicePreferredLanguage)
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    var dateString: String {
        let date = Date(timeIntervalSince1970: self)
        return Self.dateFormatter.string(from: date)
    }
}
