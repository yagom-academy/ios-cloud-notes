//
//  UIItems.swift
//  CloudNotesUITests
//
//  Created by Ryan-Son on 2021/06/15.
//

import XCTest

enum UIItems {
    static let app = XCUIApplication()
    static let navigationBar = app.navigationBars["메모"]
    static let navigationBarTitle = navigationBar.staticTexts["메모"]
    static let listCollectionView = app.collectionViews.firstMatch
    static let addNewNoteButton = app.navigationBars["메모"].buttons["Add"]
    static let swipeShareButton = app.collectionViews.buttons["Share"]
    static let activityContentNavigationBar = app.navigationBars["UIActivityContentView"]
    static let activityContentCloseButton = app.navigationBars["UIActivityContentView"].buttons["Close"]
    static let deleteButtonAppearedAsSwiped = app.collectionViews.buttons["trash"]
    static let alertElementsQuery = app.alerts["Are you sure?"].scrollViews.otherElements
    static let deleteAlertTitle = alertElementsQuery.staticTexts["Are you sure?"]
    static let deleteAlertBody = alertElementsQuery.staticTexts["Cannot recover your note after being removed."]
    static let cancelButton = alertElementsQuery.buttons["Cancel"]
    static let deleteConfirmationButton = alertElementsQuery.buttons["Delete"]
    static var cellForRowAt: (Int) -> XCUIElement = { (row: Int) in
        return app.collectionViews.children(matching: .cell).element(boundBy: row).children(matching: .other).element(boundBy: 1)
    }
    
    // detail view
    static let noteTextView = app.textViews["noteTextView"]
    static let detailViewNavigationBar = app.navigationBars["CloudNotes.NoteDetailView"]
    static let moreButton = detailViewNavigationBar.buttons["more"]
    static let backButton = detailViewNavigationBar.buttons["메모"]
    
    // keyboard
    static let backspace = "\u{8}"

    // more action sheet actions
    
    static let deleteActionSheetButtonOfMoreButton = app.sheets.scrollViews.otherElements.buttons["Delete this note"]
    static let deleteConfirmationButtonOfMoreButton = app.alerts["Are you sure?"].scrollViews.otherElements.buttons["Delete"]
    static let showActivityViewActionSheetButtonOfMoreButton = app.sheets.scrollViews.otherElements.buttons["Show activity view"]
    
    // Strings for test
    static let sampleText = """
    Learning Swift is so fun!
    UI Testing is also fun !!
    """
    static let sampleTextForFirstNote = """
    First Title
    First note
    """
    static let sampleTextForSecondNote = """
    Second Title
    Second note
    """
    static let sampleUpdatedTextForFirstNote = """
    IndexPath moved from [0, 1] to [0, 0].
    WE ARE ON FIRE!!
    """
}
