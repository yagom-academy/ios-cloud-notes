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
        guard let entity = CoreDataManager.shared.entity else {
            XCTFail()
            return
        }
        
        let memo = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.mainContext)
        memo.setValue("제목", forKey: "title")
        memo.setValue("내용내용내용", forKey: "body")
        memo.setValue(Date(), forKey: "lastModified")
        
        CoreDataManager.shared.saveContext()
       
        do {
            let memos = try CoreDataManager.shared.mainContext.fetch(Memo.fetchRequest()) as! [Memo]
            XCTAssertNil(memos.count)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_메모_객체를_만들어서_저장하기() {
        
        let newMemo = Memo(context: CoreDataManager.shared.mainContext)
        newMemo.title = "제목2222"
        newMemo.body = "내용2222"
        newMemo.lastModified = Date()
        
        CoreDataManager.shared.saveContext()
        
        do {
            let memos = try CoreDataManager.shared.mainContext.fetch(Memo.fetchRequest()) as! [Memo]
            XCTAssertNil(memos.count)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_저장된_메모_불러오기() {
        
        do {
            let memos = try CoreDataManager.shared.mainContext.fetch(Memo.fetchRequest()) as! [Memo]
            for memo in memos {
                debugPrint(memo)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_CoreDataManager_fetchMemos() {
        XCTAssertNil(CoreDataManager.shared.fetchMemos().count)
    }
    
    func test_CoreDataManager_deleteAllMemos() {
        CoreDataManager.shared.deleteAllMemos()
        XCTAssertEqual(CoreDataManager.shared.fetchMemos().count, 0)
    }
}
