//
//  Extension.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/03/02.
//

import Foundation
extension Date {
    func convertToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
}
