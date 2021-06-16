//
//  IntLiteral.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/16.
//

import Foundation

enum IntLiteral: Int {
    case First = 0
    
    var data: Int {
        return self.rawValue
    }
    
}
