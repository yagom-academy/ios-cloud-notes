//
//  JSONDecoder.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/17.
//

import UIKit

class SampleDataJSONDecoder {
    static let shared = SampleDataJSONDecoder()
    var decodedDatas: [SampleData] = []
    
    private init() {}
    
    func decodeJSONFile() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        let dataAssetName: String = "sample"
        guard let dataAsset: NSDataAsset = NSDataAsset.init(name: dataAssetName) else {
            return
        }
        
        do {
            self.decodedDatas = try jsonDecoder.decode([SampleData].self, from: dataAsset.data)
        } catch DecodingError.dataCorrupted {
            debugPrint(JSONDecodingError.dataCorrupted.errorDescription!)
        } catch DecodingError.keyNotFound {
            debugPrint(JSONDecodingError.keyNotFound.errorDescription!)
        } catch DecodingError.typeMismatch {
            debugPrint(JSONDecodingError.typeMismatch.errorDescription!)
        } catch DecodingError.valueNotFound {
            debugPrint(JSONDecodingError.valueNotFound.errorDescription!)
        } catch {
            debugPrint(JSONDecodingError.unknown.errorDescription!)
        }
    }
}
