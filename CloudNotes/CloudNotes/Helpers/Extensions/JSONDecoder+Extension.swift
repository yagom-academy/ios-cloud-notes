//
//  JSONDecoder+Extension.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit.NSDataAsset
import OSLog

extension JSONDecoder {
    convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
    
    func decode<Decoded: Decodable>(to: Decoded.Type, from assetName: String)  -> Result<Decoded, DataError> {
        let decoder = JSONDecoder(dateDecodingStrategy: .secondsSince1970)
        guard let data = NSDataAsset(name: assetName)?.data else {
            return .failure(DataError.cannotFindFile(fileName: assetName))
        }
        guard let decoded = try? decoder.decode(Decoded.self, from: data) else {
            return .failure(DataError.decodingFailed)
        }
        return .success(decoded)
    }
}
