//
//  ParsingManager.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

struct ParsingManager {
    private let jsonDecoder = JSONDecoder()
    
    func parse<T: Decodable>(fileName: String) -> [T] {
        guard let dataAsset = NSDataAsset(name: fileName) else {
            fatalError()
        }
        do {
            let result = try jsonDecoder.decode([T].self, from: dataAsset.data)
            return result
        } catch {
            fatalError()
        }
    }
}
