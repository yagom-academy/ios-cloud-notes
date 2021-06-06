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
            return "Error: Failed to load JSON data."
        case .decodeJSON:
            return "Error: Failed to decode JSON data."
        case .createItem:
            return "Error: Failed to create item."
        case .getItems:
            return "Error: Failed to get items."
        case .updateItem:
            return "Error: Failed to update item."
        case .deleteItem:
            return "Error: Failed to delete item."
        case .resetItems:
            return "Error: Failed to reset items."
        case .convertItem:
            return "Error: Failed to convert item."
        }
    }
}
