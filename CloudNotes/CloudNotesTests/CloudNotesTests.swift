//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {

    func test_샘플_데이터_Json_파싱() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let jsonData = NSDataAsset(name: "sample") else {
            XCTFail()
            return
        }
        
        guard let memoList = try? jsonDecoder.decode([Memo].self, from: jsonData.data) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(memoList.count, 15)
    }
    
    func test_Date_변환() {
        let second = 1608651333
        let date = Date(timeIntervalSince1970: TimeInterval(second))
        XCTAssertNil(date)
    }
}
