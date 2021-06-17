//
//  CloudNotesUITests - CloudNotesUITests.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import XCTest
@testable import CloudNotes

final class CloudNotesUITests: XCTestCase {
    
    override class func setUp() {
        UIItems.app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        if UIItems.backButton.exists {
            UIItems.backButton.tap()
        }
        deleteAllNotes()
    }
    
    func testListViewHasIntendedConfiguration() {
        XCTAssertTrue(UIItems.navigationBar.exists)
        XCTAssertTrue(UIItems.navigationBarTitle.exists)
        XCTAssertTrue(UIItems.addNewNoteButton.exists)
        XCTAssertTrue(UIItems.addNewNoteButton.isEnabled)
        XCTAssertTrue(UIItems.listCollectionView.exists)
    }
    
    func testCellHasIntendedConfigurationAndActions() {
        UIItems.addNewNoteButton.tap()
        UIItems.backButton.tap()
        
        XCTAssertTrue(UIItems.cellForRowAt(0).exists)
        XCTAssertTrue(UIItems.cellForRowAt(0).isEnabled)
        
        UIItems.cellForRowAt(0).swipeRight()
        XCTAssertTrue(UIItems.swipeShareButton.exists)
        XCTAssertTrue(UIItems.swipeShareButton.isEnabled)
        
        UIItems.swipeShareButton.tap()
        XCTAssertTrue(UIItems.activityContentNavigationBar.exists)
        XCTAssertTrue(UIItems.activityContentNavigationBar.isEnabled)
        
        UIItems.activityContentCloseButton.tap()
        
        UIItems.cellForRowAt(0).swipeLeft()
        XCTAssertTrue(UIItems.deleteButtonAppearedAsSwiped.exists)
        XCTAssertTrue(UIItems.deleteButtonAppearedAsSwiped.isEnabled)
        
        UIItems.deleteButtonAppearedAsSwiped.tap()
        XCTAssertTrue(UIItems.deleteAlertTitle.exists)
        XCTAssertTrue(UIItems.deleteAlertBody.exists)
        XCTAssertTrue(UIItems.cancelButton.exists)
        XCTAssertTrue(UIItems.cancelButton.isEnabled)
        XCTAssertTrue(UIItems.deleteConfirmationButton.exists)
        XCTAssertTrue(UIItems.deleteConfirmationButton.isEnabled)
        
        UIItems.deleteConfirmationButton.tap()
        
        XCTAssertEqual(UIItems.app.collectionViews.cells.count, 0)
    }
    
    func testDetailViewHasIntendedConfiguration() {
        UIItems.addNewNoteButton.tap()
        
        XCTAssertTrue(UIItems.noteTextView.exists)
        XCTAssertTrue(UIItems.noteTextView.isEnabled)
        XCTAssertTrue(UIItems.detailViewNavigationBar.exists)
        XCTAssertTrue(UIItems.moreButton.exists)
        XCTAssertTrue(UIItems.moreButton.isEnabled)
        XCTAssertTrue(UIItems.backButton.exists)
        XCTAssertTrue(UIItems.backButton.isEnabled)
    }
    
    func testCellTitleAndBodyAreShownAsIntendedThatTypedInTextView() {
        UIItems.addNewNoteButton.tap()
        UIItems.noteTextView.tap()
        UIItems.noteTextView.typeText("\(UIItems.backspace)\(UIItems.sampleText)")
        
        XCTAssertEqual(UIItems.noteTextView.value as? String, "\(UIItems.sampleText)")
        
        UIItems.backButton.tap()
        
        let split = UIItems.sampleText.split(separator: "\n")
        
        if let title = split.first, let body = split.last {
            XCTAssertTrue(UIItems.listCollectionView.cells.staticTexts[String(title)].exists)
            XCTAssertTrue(UIItems.listCollectionView.cells.staticTexts[String(body)].exists)
        } else {
            XCTFail("Test failed with unexpected text input.")
        }
    }
    
    func testCellIsRemovedWhenDeletedWithButtonOfTrailingSwipeAction() {
        UIItems.addNewNoteButton.tap()
        UIItems.backButton.tap()
        UIItems.cellForRowAt(0).swipeLeft()
        UIItems.deleteButtonAppearedAsSwiped.tap()
        UIItems.deleteConfirmationButton.tap()
        
        XCTAssertFalse(UIItems.cellForRowAt(0).exists)
        XCTAssertEqual(UIItems.listCollectionView.cells.count, 0)
    }
    
    func testCellIsRemovedWhenDeletedWithDeleteActionOfMoreButton() {
        UIItems.addNewNoteButton.tap()
        UIItems.moreButton.tap()
        UIItems.deleteActionSheetButtonOfMoreButton.tap()
        
        if UIItems.deleteConfirmationButtonOfMoreButton.waitForExistence(timeout: 1) {
            UIItems.deleteConfirmationButtonOfMoreButton.tap()
            XCTAssertFalse(UIItems.cellForRowAt(0).exists)
            XCTAssertEqual(UIItems.listCollectionView.cells.count, 0)
        } else {
            XCTFail("Cannot find delete confirmation button.")
        }
    }
    
    func testCanTriggerActivityViewWithShowActivityViewActionOfMoreButton() {
        UIItems.addNewNoteButton.tap()
        UIItems.moreButton.tap()
        UIItems.showActivityViewActionSheetButtonOfMoreButton.tap()
        
        if UIItems.activityContentNavigationBar.waitForExistence(timeout: 3) {
            XCTAssertTrue(UIItems.activityContentNavigationBar.isEnabled)
            UIItems.activityContentCloseButton.tap()
        } else {
            XCTFail("Activity content navigation bar is not shown.")
        }
    }
    
    func test_CellsAreOrganizedInDescendingOrderWhenEdited() {
        UIItems.addNewNoteButton.tap()
        UIItems.noteTextView.tap()
        UIItems.noteTextView.typeText("\(UIItems.backspace)\(UIItems.sampleTextForFirstNote)")
        UIItems.backButton.tap()
        
        UIItems.addNewNoteButton.tap()
        UIItems.noteTextView.tap()
        UIItems.noteTextView.typeText("\(UIItems.backspace)\(UIItems.sampleTextForSecondNote)")
        UIItems.backButton.tap()
        
        UIItems.cellForRowAt(1).tap()
        UIItems.noteTextView.clearText()

        UIItems.noteTextView.typeText(UIItems.sampleUpdatedTextForFirstNote)
        
        let split = UIItems.sampleUpdatedTextForFirstNote.split(separator: "\n")
        
        UIItems.backButton.tap()
        XCTAssertEqual(UIItems.listCollectionView.cells.count, 2)
        
        if let updatedTitle = split.first, let updatedBody = split.last {
            XCTAssertTrue(UIItems.listCollectionView.cells.staticTexts[String(updatedTitle)].exists)
            XCTAssertTrue(UIItems.listCollectionView.cells.staticTexts[String(updatedBody)].exists)
            UIItems.cellForRowAt(0).tap()
            XCTAssertEqual(UIItems.noteTextView.value as? String, UIItems.sampleUpdatedTextForFirstNote)
            UIItems.backButton.tap()
            
            UIItems.cellForRowAt(1).tap()
            XCTAssertEqual(UIItems.noteTextView.value as? String, UIItems.sampleTextForSecondNote)
        } else {
            XCTFail("Test failed with unexpected text input.")
        }
    }

    // MARK: - Unit Test Supporting Methods
    
    func deleteAllNotes() {
        while UIItems.cellForRowAt(0).exists {
            UIItems.cellForRowAt(0).swipeLeft()
            UIItems.deleteButtonAppearedAsSwiped.tap()
            UIItems.deleteConfirmationButton.tap()
        }
    }
}
