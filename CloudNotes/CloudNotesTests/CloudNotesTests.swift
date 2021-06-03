//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

final class CloudNotesTests: XCTestCase {
    func testNoteModelDecodingWhenTestedWithSampleJSON() {
        let decoder = JSONDecoder(dateDecodingStrategy: .secondsSince1970)
        
        guard let data = NSDataAsset(name: NoteListViewController.NoteData.sampleFileName)?.data else {
            XCTFail(DataError.cannotFindFile.localizedDescription)
            return
        }
        let notes = try? decoder.decode([Note].self, from: data)
        
        XCTAssertNotNil(notes, "Failed to Decode")
    }
    
    func testLoadNotesFromSampleFile() {
        let decoder = JSONDecoder(dateDecodingStrategy: .secondsSince1970)
        
        guard let data = NSDataAsset(name: NoteListViewController.NoteData.sampleFileName)?.data else {
            XCTFail(DataError.cannotFindFile.localizedDescription)
            return
        }
        guard let notes = try? decoder.decode([Note].self, from: data) else {
            XCTFail(DataError.decodingFailed.localizedDescription)
            return
        }
        
        let loadedResult = NoteListViewController().loadNotes(from: NoteListViewController.NoteData.sampleFileName)
        
        switch loadedResult {
        case .success(let loadedNotes):
            for index in 0...(loadedNotes.count - 1) {
                XCTAssertEqual(loadedNotes[index].title, notes[index].title)
                XCTAssertEqual(loadedNotes[index].body, notes[index].body)
                XCTAssertEqual(loadedNotes[index].lastModified, notes[index].lastModified)
            }
        case .failure(let dataError):
            XCTFail(dataError.localizedDescription)
        }
    }
}
