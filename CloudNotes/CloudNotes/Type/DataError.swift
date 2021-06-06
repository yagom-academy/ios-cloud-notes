//
//  DataError.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/02.
//

import Foundation

enum DataError: Error {
    case loadJSON
    case decodeJSON
    case createItem
    case getItems
    case updateItem
    case deleteItem
    case resetItems
    case convertItem
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loadJSON:
            return "Failed to load JSON data."
        case .decodeJSON:
            return "Failed to decode JSON data."
        case .createItem:
            return "Failed to create item."
        case .getItems:
            return "Failed to get items."
        case .updateItem:
            return "Failed to update item."
        case .deleteItem:
            return "Failed to delete item."
        case .resetItems:
            return "Failed to reset items."
        case .convertItem:
            return "Failed to convert item."
        }
    }
}
