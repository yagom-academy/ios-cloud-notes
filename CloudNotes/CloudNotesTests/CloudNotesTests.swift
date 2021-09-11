//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    var sut_dateFormatter: CurrentLocaleDateFormatter?
    
    override func setUpWithError() throws {
        sut_dateFormatter = CurrentLocaleDateFormatter()
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

    func test_DateFormatter로Locale은current고dateType은long으로포맷하면_CurrentLocaleDateFormatter로포맷한것과_같다() {
        // Given
        let date = Date()
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .long
            return dateFormatter
        }()
        let expectedValue = dateFormatter.string(from: date)
        
        // When
        let outcome = sut_dateFormatter?.format(lastModified: date.timeIntervalSince1970)
        
        // Then
        XCTAssertEqual(expectedValue, outcome)
    }
}
