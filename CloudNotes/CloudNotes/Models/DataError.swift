//
//  DataError.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import Foundation

enum DataError: Error {
    case decodingFailed
    case cannotFindFile
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cannotFindFile:
            return "Failed to decode. Please check if the file name is correct."
        case .decodingFailed:
            return "Failed to decode. Please check if the file format is written in JSON"
        }
    }
}
