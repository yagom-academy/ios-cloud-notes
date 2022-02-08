//
//  Int+dateString.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import Foundation

extension Int {
    private static let dateFormatter = DateFormatter()
    
    var dateString: String {
        Self.dateFormatter.dateStyle = .long
        Self.dateFormatter.locale = Locale.current
        
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return Self.dateFormatter.string(from: date)
    }
}
