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
    
    func updateMemo(_ title: String, _ body: String, _ lastModified: Double)
}

class Memo: Decodable, Memorable {
    var title: String
    var body: String
    var lastModified: Double
    
    func updateMemo(_ title: String, _ body: String, _ lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}

class MemoData: Memorable {
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
    
    func updateMemo(_ title: String, _ body: String, _ lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
}
