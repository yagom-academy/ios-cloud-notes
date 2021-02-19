//
//  MemoError.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import Foundation

enum MemoError: Error {
    case decodeData
    case unknown
}

extension MemoError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodeData:
            return "데이터를 변환하는데 실패했습니다.\n잠시 후 다시 시도해 주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        }
    }
}
