//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

class CloudNotesTests: XCTestCase {
    var noteListViewModel: NoteListViewModel!
    var noteDatas: [NoteData] = []
    
    override func setUpWithError() throws {
        noteListViewModel = NoteListViewModel()
        let jsonData = NSDataAsset(name: "sample")?.data
        let data = try! JSONDecoder().decode([NoteData].self, from: jsonData!)
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
