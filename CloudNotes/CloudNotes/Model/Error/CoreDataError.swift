//
//  CoreDataError.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/11.
//

import Foundation

enum CoreDataError: Error, LocalizedError {
    case fetchError
    case saveError
    case deletError
    case updateError
    
    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "fetch에 실패했습니다."
        case .saveError:
            return "save에 실패했습니다."
        case .deletError:
            return "delet에 실패했습니다."
        case .updateError:
            return "update에 실패했습니다."
        }
    }
}
