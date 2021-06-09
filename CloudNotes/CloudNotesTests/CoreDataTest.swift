//
//  CoreDataTest.swift
//  CloudNotesTests
//
//  Created by steven on 2021/06/09.
//

import XCTest
import CoreData
@testable import CloudNotes

class CoreDataTest: XCTestCase {

    func test_CoreData에_저장하고_확인하기() {
        
        // context를 가져 온다. -> CoreDataManager 안에 있음.
        
        // Entity를 가져온다.
        guard let entity = CoreDataManager.shared.entity else {
            XCTFail()
            return
        }
        
        let memo = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.mainContext)
        memo.setValue("제목", forKey: "title")
        memo.setValue("내용내용내용", forKey: "body")
//        memo.setValue(NSData(), forKey: "lastModified")
        
        CoreDataManager.shared.saveContext()
       
        do {
            let memos = try CoreDataManager.shared.mainContext.fetch(Memo.fetchRequest()) as! [Memo]
            XCTAssertNil(memos.count)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        
    }
}
