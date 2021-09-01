//
//  Memo.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import Foundation

protocol MemoContainer {
    var memo: [Memo] { get }
}

extension MemoContainer {
    var memo: [Memo] {
        return JsonManager.jsonDecode()
    }
}

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: Int
    
    var locationDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        print(Locale.current.identifier)
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        let date = Date(timeIntervalSince1970: TimeInterval(lastModified))
        
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}
