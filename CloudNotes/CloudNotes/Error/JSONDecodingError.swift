//
//  JSONDecodingError.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/16.
//

import Foundation

enum JSONDecodingError: Error {
    case dataCorrupted
    case keyNotFound
    case typeMismatch
    case valueNotFound
    case unknown
}

extension JSONDecodingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .dataCorrupted:
            return "데이터가 손상되었거나 유효하지 않습니다."
        case .keyNotFound:
            return "주어진 키를 찾을수 없습니다."
        case .typeMismatch:
            return "주어진 타입과 일치하지 않습니다."
        case .valueNotFound:
            return "예상하지 않은 null 값이 발견되었습니다."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
