//
//  CoreDataError.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/13.
//

import Foundation

enum CoreDataError {
    case fetch(Error?)
    case indexPath
    case save(Error?)
}

extension CoreDataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fetch(let error):
            return "⛔️ CoreData fetch Error: \(String(describing: error))"
        case .indexPath:
            return "⛔️ CoreData invalid IndaxPath Error"
        case .save(let error):
            return "⛔️ CoreData save Error: \(String(describing: error))"
        }
    }
}
