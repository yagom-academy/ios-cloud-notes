//
//  SampleData.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/16.
//

import Foundation

struct SampleData: Decodable {
    let title: String
    let body: String
    let lastModifiedDate: Int
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case lastModifiedDate = "last_modified"
    }
}
