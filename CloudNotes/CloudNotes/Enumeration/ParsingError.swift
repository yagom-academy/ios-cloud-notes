//
//  ParsingError.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/06.
//

import Foundation

enum ParsingError: Error, LocalizedError {
    case assetError
    case decodingError
    
    var errorDescription: String {
        switch self {
        case .assetError:
            return "에셋 데이터를 불러오던 도중 문제가 발생하였습니다."
        case .decodingError:
            return "디코딩을 하는 도중 문제가 발생했습니다."
        }
    }
}
