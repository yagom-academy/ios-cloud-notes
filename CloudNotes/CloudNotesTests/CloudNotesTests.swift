//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    var sut_dateFormatter: DateFormattable?
    class MockForDateFormattable: DateFormattable {}
    
    override func setUpWithError() throws {
        sut_dateFormatter = MockForDateFormattable()
    }

    override func tearDownWithError() throws {
        sut_dateFormatter = nil
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

    func test_sample파일의0번인덱스항목의lastModified구했을때_DateFormattable의format함수로포맷하면_2020점공백12점공백23이다() {
        // Given
        let expectedValue = "2020. 12. 23"
        let targetIndex = 0
        let sampleFileName = "sample"
        let sampleData = NSDataAsset(name: sampleFileName)?.data
        let parsedResult = sampleData?.parse(type: [Note].self)
        var lastModified: Double?
        
        switch parsedResult {
        case .success(let parsedData):
            lastModified = parsedData[targetIndex].lastModified
        default:
            XCTFail("sample 데이터의 파싱에 실패했습니다")
        }
        
        // When
        let outcome = sut_dateFormatter?.format(lastModified: lastModified ?? 0)
        
        // Then
        XCTAssertEqual(expectedValue, outcome)
    }
}
