//
//  DataHolder.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

class MemoData {
    static var list = generateList()
    
    private init() { }
    
    private static func generateList() -> [MemoDecodeModel]? {
        guard let dataAsset = NSDataAsset(name: "sample")?.data else { return nil }
        
        do {
            let decodedData = try JSONParser.decoder(modelType: [MemoDecodeModel].self, jsonData: dataAsset)
            return decodedData
        } catch {
            return nil
        }
    }
}
