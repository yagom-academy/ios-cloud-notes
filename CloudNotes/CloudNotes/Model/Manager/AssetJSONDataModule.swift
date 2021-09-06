//
//  AssetJSONDataModule.swift
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
            return "해당 에셋 파일을 찾을 수 없습니다."
        }
    }
}

struct AssetJSONDataModule: DataImportable {
    private let assetName: String
    
    init(assetName: String) {
        self.assetName = assetName
    }
    
    func importData<T: Decodable>(completionHandler: @escaping (T?, Error?) -> Void) {
        guard let sampleDataAsset = NSDataAsset(name: assetName) else {
            completionHandler(nil, AssetError.assetNotFound)
            return
        }
        
        do {
            let decodingResult = try JSONDecoder().decode(T.self, from: sampleDataAsset.data)
            completionHandler(decodingResult, nil)
        } catch {
            completionHandler(nil, error)
        }
    }
}
