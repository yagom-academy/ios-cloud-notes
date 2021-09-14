//
//  Memo.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/03.
//

import CoreData

protocol MemoModel {
    var title: String { get set }
    var body: String { get set }
    var lastModified: Double { get set }
    
    mutating func updateMemo(_ title: String, _ body: String, _ lastModified: Double)
}

struct MemoSample: Decodable, MemoModel {
    var title: String
    var body: String
    var lastModified: Double
    
    mutating func updateMemo(_ title: String, _ body: String, _ lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}

struct MemoData: MemoModel {
    var title: String
    var body: String
    var lastModified: Double
    var objectID: NSManagedObjectID?
    
    init(_ title: String, _ body: String, _ lastModified: Double, _ objectID: NSManagedObjectID?) {
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
    
    mutating func updateObjectID(_ objectID: NSManagedObjectID) {
        self.objectID = objectID
    }
}
