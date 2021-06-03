//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

final class CloudNotesTests: XCTestCase {
    func testNoteModelDecodingWhenTestedWithSampleJSON() {
        let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase,
                                  dateDecodingStrategy: .secondsSince1970)

        guard let data = NSDataAsset(name: "sample")?.data else {
            XCTFail("Cannot find the sample file from assets.")
            return
        }
        let notes = try? decoder.decode([Note].self, from: data)

        XCTAssertNotNil(notes, "Failed to Decode")
    }
}
