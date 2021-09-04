//
//  SampleDataModel.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/05.
//

import Foundation

struct SampleData: Codable {
    let title: String
    let body: String
    let lastModified: Int

    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModified = "last_modified"
    }
}
