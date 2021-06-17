//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    var noteListViewModel: NoteManager!
    var noteDatas: [Note] = []
    
    override func setUpWithError() throws {
        noteListViewModel = NoteManager()
        let jsonData = NSDataAsset(name: "sample")?.data
        let data = try! JSONDecoder().decode([Note].self, from: jsonData!)
        noteDatas = data
    }

    override func tearDownWithError() throws {
        noteListViewModel = nil
        noteDatas = []
    }

    func test_Convert_Date() {
        let date = noteListViewModel.dataAtIndex(0)
        XCTAssertEqual(date.date, "2020.12.23")
    }
}
