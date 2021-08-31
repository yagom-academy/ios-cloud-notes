//
//  ParsingManager.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/08/31.
//

import Foundation

struct ParsingManager {
    
    static func decodingModel<T: Decodable>(data: Data, model: T.Type) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(T.self, from: data)
        return model
    }
}
