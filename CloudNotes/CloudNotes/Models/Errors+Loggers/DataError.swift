//
//  DataError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit

enum DataError: Error, Equatable {
    case failedToGetNote(indexPath: IndexPath, location: String)
    case failedToSave(error: NSError)
    case failedToLoadSavedNotes(error: NSError)
    case failedToLoadPersistentStores(error: NSError)
    case cannotFindIndexPath(location: String)
    case noteNotFound
    case snapshotIsEmpty(location: String)
}

extension DataError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .failedToGetNote(indexPath, location):
            return "Failed to get note. There is no note at intended indexPath (indexPath: \(indexPath). Error occurred at \(location)"
        case let .failedToSave(error):
            return "Failed to save notes. Unresolved error \(error)."
        case let .failedToLoadSavedNotes(error):
            return "Failed to load saved notes. \(error)"
        case let .failedToLoadPersistentStores(error):
            return "Failed to load persistent stores. \(error)"
        case let .cannotFindIndexPath(location):
            return "Cannot find indexPath for the more button to work. Error occurred at \(location)"
        case .noteNotFound:
            return "There is no note in list. Please add a new note to make a memo."
        case let .snapshotIsEmpty(location):
            return "Note not found in snapshot while trying to change note. Error occurred at \(location)"
        }
    }
}
