//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {

  func test_dateFormatter() {
    guard let asset = NSDataAsset(name: "sample") else {
      XCTFail()
      return
    }
    
    do {
      let data = try JSONDecoder().decode([Memo].self, from: asset.data)
      XCTAssertEqual(data[0].title, "똘기떵이호치새초미자축인묘")
      XCTAssertEqual(data[0].lastModifiedDate, "2020. 12. 23")
    } catch {
      XCTFail()
    }
  }
}
