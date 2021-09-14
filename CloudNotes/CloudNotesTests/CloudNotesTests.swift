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
