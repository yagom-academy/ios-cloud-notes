//
//  NoteTextView.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import UIKit
import OSLog

final class NoteTextView: UITextView {
    weak var noteListViewControllerDelegate: NoteListViewControllerDelegate?
    
    private enum TextSymbols {
        static let separator: String.Element = "\n"
        static let separatorAsString = "\n"
        static let emptyContent: Substring = ""
    }
}

extension NoteTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var text = textView.text.split(separator: TextSymbols.separator, omittingEmptySubsequences: false)
        let currentDate = Date()
        guard let editingNote = noteListViewControllerDelegate?.editingNote else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.delegateNotSet(delegateName: "NoteListViewControllerDelegate").localizedDescription)
            return
        }
        var newNote = Note(with: editingNote, title: String(text.first ?? TextSymbols.emptyContent), body: String(TextSymbols.emptyContent), lastModified: currentDate)
        var textHasBody: Bool {
            text.count > 1
        }
        
        if textHasBody {
            let newTitle = text.removeFirst()
            let newBody = text.joined(separator: TextSymbols.separatorAsString)
            newNote = Note(with: editingNote, title: String(newTitle), body: newBody, lastModified: currentDate)
        }
        
        noteListViewControllerDelegate?.changeNote(with: newNote)
    }
}
