//
//  UIError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

enum UIError: Error {
    case collectionViewNotSet(location: String)
    case typeCastingFailed(subject: String, location: String)
    case cannotFindSplitViewController(location: String)
    case noteManagerNotImplemented(location: String)
}

extension UIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .collectionViewNotSet(location):
            return "Collection view is not set. Please check if you implemented collection view before configuring hierarchy with `createLayout()`. Error occurred at \(location)"
        case let .typeCastingFailed(subject, location):
            return "\(subject) failed to convert type at \(location)."
        case let .cannotFindSplitViewController(location):
            return "Cannot find split view controller. Please check if the view controller is set as child view controller of split view controller. Error occurred at \(location)"
        case let .noteManagerNotImplemented(location):
            return "NoteManager should be implemented before committing this action. Error occurred at \(location)"
        }
    }
}
