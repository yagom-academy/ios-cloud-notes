//
//  LiteralData.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/16.
//

import Foundation

enum StringLiterals: String {
    case memo = "메모"
    case lineBreak = "\n"
    case empty = ""
    case delete = "Delete"
    case share = "Share"
    case cancel = "Cancel"
    case newMemo = "새로운 메모"
    case noContent = "내용 없음"
    
    var data: String {
        return self.rawValue
    }
    
}
