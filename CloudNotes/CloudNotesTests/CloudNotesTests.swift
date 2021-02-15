//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeMemoSample() throws {
        let data = NSDataAsset(name: "sample")!
        let memoList: [Memo] = try JSONDecoder().decode([Memo].self, from: data.data)
        
        XCTAssertEqual(memoList[0].title, "똘기떵이호치새초미자축인묘")
        XCTAssertEqual(memoList[2].lastModified, 1608651333)
        XCTAssertEqual(memoList[3].title, "네번째")
        
        // 실패할 테스트
//        XCTAssertEqual(memoList[3].lastModified, 202020, "It would fail")
    }

}
