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
        
        guard let data = NSDataAsset(name: NoteListViewController.NoteData.sampleFileName)?.data else {
            XCTFail(DataError.cannotFindFile.localizedDescription)
            return
        }
        let notes = try? decoder.decode([Note].self, from: data)
        
        XCTAssertNotNil(notes, "Failed to Decode")
    }
    
    func testLoadNotesFromSampleFile() {
            let decoder = JSONDecoder(keyDecodingStrategy: .convertFromSnakeCase,
                                      dateDecodingStrategy: .secondsSince1970)

            guard let data = NSDataAsset(name: NoteListViewController.NoteData.sampleFileName)?.data else {
                XCTFail(DataError.cannotFindFile.localizedDescription)
                return
            }
            guard let notes = try? decoder.decode([Note].self, from: data) else {
                XCTFail(DataError.decodingFailed.localizedDescription)
                return
            }

            XCTAssertEqual(
                NoteListViewController().loadNotes(from: NoteListViewController.NoteData.sampleFileName),
                .success(notes)
            )
        }
}
