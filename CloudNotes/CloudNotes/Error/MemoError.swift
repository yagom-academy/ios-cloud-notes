//
//  MemoError.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import Foundation

enum MemoError: Error {
    case saveMemo
    case fetchMemo
    case updateMemo
    case deleteMemo
    case unknown
}

extension MemoError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .saveMemo:
            return "메모를 저장하는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .fetchMemo:
            return "메모를 불러오는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .updateMemo:
            return "메모를 수정하는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .deleteMemo:
            return "메모를 삭제하는 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        }
    }
}
