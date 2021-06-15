//
//  DataError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit

enum DataError: Error, Equatable {
    case editingNoteNotSet(location: String)
    case failedToGetNote(indexPath: IndexPath, location: String)
    case failedToSave(error: NSError)
    case failedToLoadSavedNotes(error: NSError)
    case failedToLoadPersistentStores(error: NSError)
    case cannotFindIndexPath(location: String)
    case noteNotFound
}

extension DataError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .editingNoteNotSet(location):
            return "Editing note is not set. Please check if you called `informEditingNote(_:indexPath:)` at the time the subject note for edit is being changed. Error occurred at \(location)"
        case let .failedToGetNote(indexPath, location):
            return "Failed to get note. There is no note in intended indexPath (indexPath: \(indexPath). Error occurred at \(location)"
        case let .failedToSave(error):
            return "Failed to save notes. Unresolved error \(error)."
        case let .failedToLoadSavedNotes(error):
            return "Failed to load saved notes. \(error)"
        case let .failedToLoadPersistentStores(error):
            return "Failed to load persistent stores. \(error)"
        case let .cannotFindIndexPath(location):
            return "Cannot find indexPath for the more button to work. Please check if you called `informEditingNote(_:indexPath:)` at the time the subject note for edit is being changed. Error occurred at \(location)"
        case .noteNotFound:
            return "There is no note in box. Please add a new note to make a memo."
        }
    }
}
