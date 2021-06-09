//
//  CoreDataError.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/10.
//

import Foundation

enum CoreDataError: LocalizedError {
    case fetchFailed

    var errorDescription: String? {
        switch self {
        case .fetchFailed:
            return "데이터를 불러오는 과정에서 오류가 발생했어요 😢"
        }
    }
}
