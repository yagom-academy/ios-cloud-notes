//
//  XCUIElement+Extension.swift
//  CloudNotesUITests
//
//  Created by Ryan-Son on 2021/06/15.
//

import XCTest

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear text, but value is not String type.")
            return
        }
        
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
