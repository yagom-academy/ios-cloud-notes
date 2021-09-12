//
//  JSONParser.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/01.
//

import Foundation

enum ParsingError: Error, LocalizedError {
    case decodedError
    
    var localizedDescription: String {
        switch self {
        case .decodedError:
            return "JSON 디코딩에서 문제가 생겼어요"
        }
    }
}

struct JSONParser {
    static func decoder<T: Decodable> (modelType: T.Type, jsonData: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(modelType, from: jsonData)
            return decodedData
        } catch {
            throw ParsingError.decodedError
        }
    }
}
