//
//  ParsingManager.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import Foundation

struct ParsingManager<T: Decodable> {
    
    private init() {}
    
    static func decode(from data: Data) -> Result<T, Error> {
        do {
            let decodingResult = try JSONDecoder().decode(T.self, from: data)
            return .success(decodingResult)
        } catch {
            return .failure(error)
        }
    }
}
