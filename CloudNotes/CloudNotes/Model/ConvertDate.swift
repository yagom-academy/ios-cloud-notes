//
//  ConvertDate.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/16.
//

import Foundation

final class ConvertDate {
    static let shared = ConvertDate()
    
    func convertDate(date: Double) -> String {
        let result = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: result)
    }
    
    func convertDouble() -> Double {
        let nowDate = Date()
        let timeInterval = nowDate.timeIntervalSince1970
        return Double(timeInterval)
    }
    
}
