//
//  StringTest.swift
//  CloudNotesTests
//
//  Created by steven on 2021/06/14.
//

import XCTest

class StringTest: XCTestCase {

    func test_String_firstIndex() {
        let str = "Hello World!!\n yagom"
        XCTAssertNil(str.distance(from: str.startIndex, to: str.firstIndex(of: "\n") ?? str.endIndex))
        let newLine = str.firstIndex(of: "0") ?? str.index(before: str.endIndex)
        let newLineNext = str.index(after: newLine)
        XCTAssertNil(str[...newLine])
        XCTAssertNil(str[newLineNext...])
    }

}
