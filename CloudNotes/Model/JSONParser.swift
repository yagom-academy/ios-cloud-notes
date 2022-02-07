//
//  JSONParser.swift
//  CloudNotes
//
//  Created by 서녕 on 2022/02/07.
//

import Foundation

enum JSONParserError: Error {
    case decodingError
}

struct JSONParser {
    func decode<T: Decodable>(from json: Data, decodingType: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let decodedData = try? decoder.decode(decodingType.self, from: json) else {
            throw JSONParserError.decodingError
        }
        return decodedData
    }
}
