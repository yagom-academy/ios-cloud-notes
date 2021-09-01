//
//  JsonManager.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import Foundation

struct JsonManager {
    static func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
        let decodedData = try? JSONDecoder().decode(type, from: data)
        return decodedData
    }
}
