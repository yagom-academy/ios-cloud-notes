//
//  NoteError.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/06.
//

import Foundation

enum DataError: Error {
    case FailedToGetData
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .FailedToGetData:
            return "데이터를 가져오지 못했습니다😢"
        }
    }
}
