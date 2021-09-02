//
//  NamePlace.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import Foundation

enum CellId {
    case defaultCell
    
    var description: String {
        switch self {
        case .defaultCell:
            return "cell"
        }
    }
}
