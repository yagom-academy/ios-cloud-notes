//
//  LiteralData.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/16.
//

import Foundation

enum StringLiteral: String {
    case memo = "memo"
    
    var data: String {
        return self.rawValue
    }
    
}
