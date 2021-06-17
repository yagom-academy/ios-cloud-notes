//
//  String+Extension.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/15.
//

import Foundation

extension String {
    var dividedIntoTitleAndBody: (title: String, body: String) {
        var text = self.split(separator: NoteManager.Texts.newLineAsElement, maxSplits: 1, omittingEmptySubsequences: false)
        let title = String(text.removeFirst())
        let body = text.joined()
        
        return (title, body)
    }
}
