//
//  ParshingManager.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/06.
//

import UIKit

struct ParsingManager {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(from fileName: String, to destinationType: T.Type)-> Result<T, ParsingError> {
        guard let asset = NSDataAsset(name: fileName) else {
            return .failure(.assetError)
        }
        guard let decodedData = try? jsonDecoder.decode(destinationType, from: asset.data) else {
            return .failure(.decodingError)
        }
        return .success(decodedData)
    }
}
