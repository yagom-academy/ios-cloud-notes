//
//  JsonManager.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import Foundation

struct JsonManager {
    static func jsonDecode() -> [Memo] {
        guard let path = Bundle.main.path(forResource: "sample", ofType: "json") else {
            return [Memo]()
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return [Memo]()
        }
        guard let sampleData = jsonString.data(using: .utf8) else {
            return [Memo]()
        }
        guard let decodedData = try? JSONDecoder().decode([Memo].self, from: sampleData) else {
            return [Memo]()
        }
        return decodedData
    }
}
