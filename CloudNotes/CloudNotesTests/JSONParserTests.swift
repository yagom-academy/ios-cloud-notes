//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class JSONParserTests: XCTestCase {
    func test_JSONParser_decode메서드가_정상작동하는지() throws {
        guard let jsonData = NSDataAsset(name: "sample")?.data else {
            XCTFail()
            return
        }
        
        let result = JSONParser().decode(
          from: jsonData,
          decodingType: [NoteInformation].self
        )
        
        switch result {
        case .success(let noteInformations):
            XCTAssertEqual(noteInformations.count, 15)
            XCTAssertEqual(noteInformations[0].title, "똘기떵이호치새초미자축인묘")
        case .failure(let error):
            XCTAssertEqual(error, .decodingError)
        }
    }
}
