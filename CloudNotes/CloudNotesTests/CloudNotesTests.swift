//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    func test_ParsingManagerTest() {
        // given
        var data = [CloudNoteItem]()
        // when
        data = ParsingManager().parse(fileName: "sample")
        // then
        print(data)
        XCTAssertNotNil(data)
    }
}
