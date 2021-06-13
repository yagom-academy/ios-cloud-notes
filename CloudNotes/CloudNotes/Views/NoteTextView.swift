//
//  NoteTextView.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import UIKit
import OSLog

final class NoteTextView: UITextView {
    weak var noteManagerDelegate: NoteManagerDelegate?
}

extension NoteTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        noteManagerDelegate?.changeNote(with: textView.text)
    }
}
