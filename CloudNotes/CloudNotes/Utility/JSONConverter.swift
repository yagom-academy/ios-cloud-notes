//
//  JSONConverter.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

struct JSONConverter<T: Decodable> {
    private let decoder = JSONDecoder()
    private let dateFormatter = DateFormatter()
    
    func decode(from fileName: String) -> T? {
        guard let dataAsset = NSDataAsset(name: fileName) else {
            return nil
        }
        
        dateFormatter.locale = Locale.current
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let decodedData = try? decoder.decode(T.self, from: dataAsset.data)
        return decodedData
    }
}
