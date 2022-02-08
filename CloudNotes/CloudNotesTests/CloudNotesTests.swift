//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_JSON데이터를_Note타입으로_Deconding하여_인스턴스를_반환해야합니다() throws {
        // given
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        // when
        let jsonAsset = NSDataAsset(name: "sample")
        guard let jsonData = jsonAsset?.data else {
            XCTFail()
            return
        }
        
        // then
        let result = try? decoder.decode([Note].self, from: jsonData)
        XCTAssertNotNil(result)
    }

}
