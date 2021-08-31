//
//  jsonHandler.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import Foundation

struct JSONHandler {
    func decode<T: Decodable>(with data: Data, to model: T.Type) -> T? {
        return try? JSONDecoder().decode(model, from: data)
    }
}

enum JsonUtil {
    static func loadJsonData(_ name: String) -> Data? {
        if let path = Bundle.main.path(forResource: name, ofType: "json"),
           let jsonData = try? String(contentsOfFile: path).data(using: .utf8) {
            return jsonData
        }
        return nil
    }
}
