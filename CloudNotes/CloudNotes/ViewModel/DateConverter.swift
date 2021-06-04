//
//  MemoListCellModel.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import Foundation

struct DateConverter {
    mutating func convertDate(date: Double) -> String {
        let result = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: result)
    }
    
}
