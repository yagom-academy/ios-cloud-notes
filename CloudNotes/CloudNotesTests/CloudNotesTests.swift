//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    func test_JSONConverter을_통한_json파싱이_정상적으로_되는지() {
        let jsonConverter = JSONConverter<[Memo]>()
        let result = jsonConverter.decode(from: "sample")
        
        XCTAssertEqual(result?.first?.title, "똘기떵이호치새초미자축인묘")
        XCTAssertEqual(result?.first?.lastModified, 1608651333)
    }
}
