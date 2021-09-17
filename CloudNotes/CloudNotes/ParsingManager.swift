//
//  ParsingManager.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

enum ParsingError: Error, CustomStringConvertible {
    case parsingError
    case noFile
    
    var description: String {
        switch self {
        case .parsingError:
            return "parsingError"
        case .noFile:
            return "파일 없음"
        }
    }
}

struct ParsingManager {
    private let jsonDecoder = JSONDecoder()
    
    func parse<T: Decodable>(fileName: String) throws -> [T] {
        guard let dataAsset = NSDataAsset(name: fileName) else {
            throw ParsingError.noFile
        }
        let result = try jsonDecoder.decode([T].self, from: dataAsset.data)
        
        return result
    }
}
