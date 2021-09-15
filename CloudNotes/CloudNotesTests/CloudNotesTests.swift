//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
import CoreData
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    var testCoreData: CoreDataCloudMemo!
    
    override func setUp() {
        super.setUp()
        let persistentStroeDescription = NSPersistentStoreDescription()
        persistentStroeDescription.type = NSInMemoryStoreType
        testCoreData = CoreDataCloudMemo(persistentStoreDescripntion: persistentStroeDescription)
    }
    
    func test_코어데이터에_메모를_추가하는게_성공한다() {
        // given
        let newMemo = testCoreData.createNewMemo(title: "hi", body: "body", lastModifier: Date())
        
        // when
        let memos = try! testCoreData.context.fetch(CloudMemo.fetchRequest()) as! [CloudMemo]
        
        // then
        XCTAssertEqual(newMemo, memos.first!)
    }
    
    func test_코어데이터_메모를_삭제하는게_성공한다() {
        // given
        let newMemo = testCoreData.createNewMemo(title: "hi", body: "body", lastModifier: Date())
        
        // when
        testCoreData.deleteObject(_ object: newMemo)
        let memos = try! testCoreData.context.fetch(CloudMemo.fetchRequest()) as! [CloudMemo]
        
        // then
        XCTAssertTrue(memos.isEmpty)
    }
    
    func test_코어데이터_메모를_업데이트하는데_성공한다() {
        // given
        let newMemo = testCoreData.createNewMemo(title: "hi", body: "body", lastModifier: Date())

        // when
        testCoreData.updateObject(newMemo) { memo in
            let memo = memo as! CloudMemo
            memo.title = "newMemo"
            memo.body = "바디입니다."
        }
        
        let memos = try! testCoreData.context.fetch(CloudMemo.fetchRequest()) as! [CloudMemo]
        
        // then
        XCTAssertEqual(memos.first!.title, "newMemo")
    }
}
