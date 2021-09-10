//
//  Extention + DateFormatter.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/08.
//

import Foundation

extension DateFormatter {
    static func localizedString(of lastModifier: Date?) -> String {
        guard let lastModifier = lastModifier else {
            return ""
        }
        
        let currentLanguage = Locale.preferredLanguages.first
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: currentLanguage ?? "en_US")
        
        return dateFormatter.string(from: lastModifier)
    }
}
