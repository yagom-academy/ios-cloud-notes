//
//  UIError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

enum UIError: Error {
    case collectionViewNotSet
}

extension UIError: LocalizedError {
    var failureReason: String? {
        switch self {
        case .collectionViewNotSet:
            return "Collection view is not set."
        }
    }
}
