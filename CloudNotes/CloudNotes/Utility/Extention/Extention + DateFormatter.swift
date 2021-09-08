//
//  Extention + DateFormatter.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/08.
//

import Foundation

extension DateFormatter {
    static func localizedString(of lastModifier: Int) -> String {
        let currentLanguage = Locale.preferredLanguages.first
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(lastModifier))
        
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: currentLanguage ?? "en_US")
        
        return dateFormatter.string(from: date)
    }
}
