//
//  LocalJSONDataModule.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/06.
//

import Foundation
import UIKit.NSDataAsset

enum AssetError: Error, LocalizedError {
    case assetNotFound
    
    var errorDescription: String? {
        switch self {
        case .assetNotFound:
            return "데이터를 찾을 수 없습니다."
        }
    }
}

struct LocalJSONDataModule<T: Decodable>: DataImportable {
    private let assetName: String
    
    init(assetName: String) {
        self.assetName = assetName
    }
    
    func importData(completionHandler: @escaping (T?, Error?) -> Void) {
        guard let sampleDataAsset = NSDataAsset(name: assetName) else {
            completionHandler(nil, AssetError.assetNotFound)
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: sampleDataAsset.data)
            completionHandler(decodedData, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
}
