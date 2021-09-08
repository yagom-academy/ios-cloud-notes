//
//  Decodable+Extension.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import Foundation

enum ParsingError: Error {
    case invalidData
    case invalidModelType
}

extension Decodable {
    func parse<T: Decodable>(type: T.Type) -> Result<T, ParsingError> {
        guard let data = self as? Data else {
            return .failure(ParsingError.invalidData)
        }
        guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
            return .failure(ParsingError.invalidModelType)
        }
        return .success(decodedData)
    }
}
