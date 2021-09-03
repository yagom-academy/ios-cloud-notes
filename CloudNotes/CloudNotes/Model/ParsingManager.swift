//
//  ParsingManager.swift
//  CloudNotes
//
//  Created by 오승기 on 2021/09/03.
//

import Foundation

struct ParsingManager {
    
    static func decodingModel<T: Decodable>(data: Data, model: T.Type) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(T.self, from: data)
        return model
    }
}
