//
//  JSONParser.swift
//  CloudNotes
//
//  Created by 서녕 on 2022/02/07.
//

import Foundation

enum JSONParserError: Error, LocalizedError {
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "디코딩에 실패했습니다."
        }
    }
}

struct JSONParser {
    func decode<T: Decodable>(
      from json: Data,
      decodingType: T.Type
    ) -> Result<T, JSONParserError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedData = try? decoder.decode(
            decodingType.self,
            from: json)
        else {
            return .failure(.decodingError)
        }
        return .success(decodedData)
    }
}
