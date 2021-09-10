//
//  Memo.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

import CoreData

protocol Memorable {
    var title: String { get set }
    var body: String { get set }
    var lastModified: Double { get set }
    
    mutating func updateMemo(_ title: String, _ body: String, _ lastModified: Double)
}

struct Memo: Decodable, Memorable {
    var title: String
    var body: String
    var lastModified: Double
    
    mutating func updateMemo(_ title: String, _ body: String, _ lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}

struct MemoData: Memorable {
    enum MemoKeys {
        case modelName
        case title
        case body
        case lastModified
        
        var key: String {
            switch self {
            case .modelName:
                return "Memo"
            case .title:
                return "title"
            case .body:
                return "body"
            case .lastModified:
                return "lastModified"
            }
        }
    }
    
    var title: String
    var body: String
    var lastModified: Double
    var objectID: NSManagedObjectID?
    
    init(_ title: String, _ body: String, _ lastModified: Double, _ objectID: NSManagedObjectID) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
        self.objectID = objectID
    }
    
    mutating func updateMemo(_ title: String, _ body: String, _ lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}
