//
//  Extention.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/17.
//

import Foundation

extension Int {
    var dateToString: String {
        let date = Date(timeIntervalSince1970: Double(self))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy. MM. dd."
        return dateFormatter.string(from: date)
    }
}
