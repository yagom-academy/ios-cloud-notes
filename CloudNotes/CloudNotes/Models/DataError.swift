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
    case dataSourceNotSet
    case failedToSave(error: NSError)
    case failedToLoadSavedNotes(error: NSError)
    case failedToLoadPersistentStores(error: NSError)
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .cannotFindFile(fileName):
            return "Failed to decode. Please check the file name is correct. The file name you entered is \(fileName)"
        case .decodingFailed:
            return "Failed to decode. Please check if the file format is written in JSON and coding keys are available."
        case .dataSourceNotSet:
            return "Diffable data source is not set."
        case let .failedToSave(error):
            return "Failed to save notes. Unresolved error \(error)."
        case let .failedToLoadSavedNotes(error):
            return "Failed to load saved notes. \(error)"
        case let .failedToLoadPersistentStores(error):
            return "Failed to load persistent stores. \(error)"
        }
    }
}
