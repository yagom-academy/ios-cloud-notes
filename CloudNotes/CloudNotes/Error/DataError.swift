//
//  NoteError.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/06.
//

import Foundation

enum DataError: Error {
    case decodingFailed
    case notFoundAsset
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingFailed:
            return "디코딩 실패🚨"
        case .notFoundAsset:
            return "Asset을 찾을 수 없습니다😢"
        }
    }
}
