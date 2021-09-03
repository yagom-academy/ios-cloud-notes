//
//  MockModel.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/03.
//

import Foundation

struct MockModel: Savable {
    var title: String? = {
        return ["AAAA", "BBBB", "CCCC"].randomElement()
    }()
    var body: String? = {
        return ["AAAA", "BBBB", "CCCC"].randomElement()
    }()
    var lastModified: Int? = {
        return [20210101, 20210202, 20210303].randomElement()
    }()
}
