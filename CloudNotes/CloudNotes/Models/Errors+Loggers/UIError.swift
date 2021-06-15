//
//  UIError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

enum UIError: Error {
    case collectionViewNotImplemented(location: String)
    case typeCastingFailed(subject: String, location: String)
    case cannotFindSplitViewController(location: String)
}

extension UIError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .collectionViewNotImplemented(location):
            return "Collection view is not implementd. Please check if you set collection view before configuring hierarchy with `createLayout()`. Error occurred at \(location)"
        case let .typeCastingFailed(subject, location):
            return "\(subject) failed to convert type at \(location)."
        case let .cannotFindSplitViewController(location):
            return "Cannot find split view controller. Please check if the view controller is set as child view controller of split view controller. Error occurred at \(location)"
        }
    }
}
