//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

final class CloudNotesTests: XCTestCase {
    func testNoteModelDecodingWhenTestedWithSampleJSONReturnsDecodedResult() {
        let decoded = JSONDecoder().decode(to: [Note].self, from: NoteListViewController.NoteData.sampleFileName)
        
        XCTAssertNotNil(decoded, "Failed to Decode")
    }
    
    func testNoteModelDecodingWhenTestedWithInvalidJSONReturnsFailureWithCannotFindFileError() {
        let decoded = JSONDecoder().decode(to: [Note].self, from: "some invalid file")
        
        XCTAssertEqual(decoded, .failure(.cannotFindFile))
    }
}
