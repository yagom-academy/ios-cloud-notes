//
//  Sample.swift
//  CloudNotes
//
//  Created by Ellen on 2021/09/07.
//

import Foundation

struct MemoList: Decodable {
    var title: String
    var body: String
    var lastModified: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}

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
