//
//  DefaultMemo.swift
//  CloudNotes
//
//  Created by 1 on 2022/02/24.
//

import Foundation

enum Memo {
    case defaults
    
    var attributes: [String: Any] {
        ["title": "새로운 메모", "body": "", "lastModified": Date(), "identifier": UUID()] as [String: Any]
    }
}
