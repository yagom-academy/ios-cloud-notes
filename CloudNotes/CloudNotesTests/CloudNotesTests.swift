//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Given
        
        // When
        
        // Then
        
    }

    func test_이름이sample인파일의데이터를_parse함수로Note배열타입으로파싱하면_인덱스3인항목의title은네번째다() {
        // Given
        let sampleFileName = "sample"
        let sampleData = NSDataAsset(name: sampleFileName)?.data
        let expectedValue = "네번째"
        let targetIndex = 3
        
        // When
        let parsedResult = sampleData?.parse(type: [Note].self)
        var outcome: String?
        
        switch parsedResult {
        case .success(let parsedData):
            outcome = parsedData[targetIndex].title
        default:
            XCTFail("sample 데이터의 파싱에 실패했습니다")
        }
            
        // Then
        XCTAssertEqual(expectedValue, outcome)
    }

}
