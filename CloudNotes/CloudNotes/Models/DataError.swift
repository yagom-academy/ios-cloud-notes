//
//  DataError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit

enum DataError: Error, Equatable {
    case diffableDataSourceNotImplemented(location: String)
    case editingNoteNotSet(location: String)
    case failedToConfigureDiffableDataSource(location: String)
    case failedToGetNote(indexPath: IndexPath, location: String)
    case failedToSave(error: NSError)
    case failedToLoadSavedNotes(error: NSError)
    case failedToLoadPersistentStores(error: NSError)
    case failedToDeleteNote(indexPath: IndexPath)
    case snapshotIsEmpty(location: String)
    case cannotFindIndexPath(location: String)
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .diffableDataSourceNotImplemented(location):
            return "Diffable data source is not implemented. Error occurred at: \(location)"
        case let .editingNoteNotSet(location):
            return "Editing note is not set. Please check if you called `informEditingNote(_:indexPath:)` at the time the subject note for edit is being changed. Error occurred at \(location)"
        case let .failedToConfigureDiffableDataSource(location):
            return "Failed to configure collection view diffable data source. This may happened if the listViewDataSource or collection view is not implemented when this method requests. Error occurred at \(location)"
        case let .failedToGetNote(indexPath, location):
            return "Failed to get note. There is no note in intended indexPath (indexPath: \(indexPath) or diffable data source is not implemented. Error occurred at \(location)"
        case let .failedToSave(error):
            return "Failed to save notes. Unresolved error \(error)."
        case let .failedToLoadSavedNotes(error):
            return "Failed to load saved notes. \(error)"
        case let .failedToLoadPersistentStores(error):
            return "Failed to load persistent stores. \(error)"
        case let .failedToDeleteNote(indexPath):
            return "Failed to delete note. Please check if selected note is valid in snapshot, the data source and fetched results controller is implemented. IndexPath: \(indexPath)"
        case let .snapshotIsEmpty(location):
            return "No note found in snapshot while trying to change note. Error occurred at \(location)"
        case let .cannotFindIndexPath(location):
            return "Cannot find indexPath for the ellipsis button to work. Please check if you called `informEditingNote(_:indexPath:)` at the time the subject note for edit is being changed. Error occurred at \(location)"
        }
    }
}
