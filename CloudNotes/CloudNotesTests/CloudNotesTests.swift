//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {

    func test_MemoType_Decoding() {
        guard let data: NSDataAsset = NSDataAsset(name: "sample") else {
            print("에셋 데이터 읽어오기 실패")
            XCTFail()
            return
        }
        
        guard let _ = try? JSONDecoder().decode([Memo].self, from: data.data) else {
            print("Memo 타입 디코딩 실패")
            XCTFail()
            return
        }
    }

}
