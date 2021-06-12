//
//  DataError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

enum DataError: Error, Equatable {
    case decodingFailed
    case cannotFindFile(fileName: String)
    case dataSourceNotSet(location: String)
    case failedToSave(error: NSError)
    case failedToLoadSavedNotes(error: NSError)
    case failedToLoadPersistentStores(error: NSError)
    case failedToDeleteNote(indexPath: IndexPath)
    case snapshotIsEmpty(location: String)
    case failedToCreateNote(location: String)
    case cannotFindIndexPath(location: String)
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .cannotFindFile(fileName):
            return "Failed to decode. Please check the file name is correct. The file name you entered is \(fileName)"
        case .decodingFailed:
            return "Failed to decode. Please check if the file format is written in JSON and coding keys are available."
        case let .dataSourceNotSet(location):
            return "Diffable data source is not set. Error occurred at: \(location)"
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
        case let .failedToCreateNote(location):
            return "Failed to create a note while adding a new note. Error occurred at \(location)"
        case let .cannotFindIndexPath(location):
            return "Cannot find indexPath for the ellipsis button to work. Error occurred at \(location)"
        }
    }
}
