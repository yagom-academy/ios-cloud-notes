//
//  NamePlace.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import Foundation

enum CellID {
    case defaultCell
    
    var identifier: String {
        switch self {
        case .defaultCell:
            return "cell"
        }
    }
}
