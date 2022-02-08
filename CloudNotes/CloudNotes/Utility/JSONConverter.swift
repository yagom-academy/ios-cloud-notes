//
//  JSONConverter.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

struct JSONConverter<T: Decodable> {
    private let decoder = JSONDecoder()
    
    func decode(from fileName: String) -> T? {
        guard let dataAsset = NSDataAsset(name: fileName) else {
            return nil
        }
        
        let decodedData = try? decoder.decode(T.self, from: dataAsset.data)
        return decodedData
    }
}
