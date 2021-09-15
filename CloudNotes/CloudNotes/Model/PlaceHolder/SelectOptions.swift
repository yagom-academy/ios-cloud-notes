//
//  SelectOptions.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/15.
//

import Foundation

enum SelectOptions {
    case delete
    case share
    case cancle
    
    var literal: String {
        switch self {
        case .delete:
            return "Delete"
        case .share:
            return "Share..."
        case .cancle:
            return "Cancle"
        }
    }
}
