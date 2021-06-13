//
//  CloudNotesTests - CloudNotesTests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

final class CloudNotesTests: XCTestCase {
    var mockCoreDataStack: CoreDataStack!
    var sutNoteManager: NoteManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCoreDataStack = MockNoteCoreDataStack()
        sutNoteManager = NoteManager(coreDataStack: mockCoreDataStack)
        sutNoteManager.loadSavedNotes()
    }
    
    override func tearDownWithError() throws {
        mockCoreDataStack = nil
        sutNoteManager = nil
        try super.tearDownWithError()
    }
    
    func testCreateNewNote() {
        let newNote = sutNoteManager.createNewNote(title: TestAssets.title, body: TestAssets.body, date: TestAssets.date)
        
        XCTAssertNotNil(newNote)
        XCTAssertEqual(newNote.title, TestAssets.title)
        XCTAssertEqual(newNote.body, TestAssets.body)
        XCTAssertEqual(newNote.lastModified, TestAssets.date)
    }
    
    func testContextIsSavedAfterCreatingNote() {
        let newNote = sutNoteManager.createNewNote(title: TestAssets.title, body: TestAssets.body, date: TestAssets.date)
        
        XCTAssertTrue(sutNoteManager.fetchedNotes.contains(newNote))
    }
    
    func testReceivedNoteIsSameAsCreated() {
        let newNote = sutNoteManager.createNewNote(title: TestAssets.title, body: TestAssets.body, date: TestAssets.date)
        
        let received = sutNoteManager.getNote(at: TestAssets.indexPathOfFirstNote)
        
        XCTAssertEqual(newNote, received)
    }
    
    func testInformEditingNote() {
        let editingNote = sutNoteManager.createNewNote(title: TestAssets.title, body: TestAssets.body, date: TestAssets.date)
        let noteDetailViewController = NoteDetailViewController()
        sutNoteManager.noteDetailViewControllerDelegate = noteDetailViewController
        
        sutNoteManager.informEditingNote(editingNote, indexPath: TestAssets.indexPathOfFirstNote)
        
        XCTAssertEqual(sutNoteManager.editingNote, editingNote)
        XCTAssertEqual(noteDetailViewController.currentIndexPathForSelectedNote, TestAssets.indexPathOfFirstNote)
    }
    
    func testUpdateNote() {
        let editingNote = sutNoteManager.createNewNote(title: TestAssets.title, body: TestAssets.body, date: TestAssets.date)
        sutNoteManager.informEditingNote(editingNote, indexPath: nil)
        let updatedText = TestAssets.updatedTitle + TestAssets.titleBodySeparator + TestAssets.updatedBody
        
        let updated = sutNoteManager.updateNote(with: updatedText)
        
        XCTAssertEqual(updated?.title, TestAssets.updatedTitle)
        XCTAssertEqual(updated?.body, TestAssets.updatedBody)
        XCTAssertEqual(updated?.lastModified.formatted, TestAssets.updatedDate.formatted)
    }
    
    func testDeleteNote() {
        let noteToDelete = sutNoteManager.createNewNote(title: TestAssets.title, body: TestAssets.body, date: TestAssets.date)
        
        let deleted = sutNoteManager.deleteNote(noteToDelete)
        
        XCTAssertEqual(deleted, noteToDelete)
    }
}
