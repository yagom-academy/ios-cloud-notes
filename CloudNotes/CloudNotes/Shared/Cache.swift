//
//  Cache.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/06/02.
//

import Foundation

struct Cache {
    static var shared = Cache()
    let decodedJsonData: [Memo] = []
}
