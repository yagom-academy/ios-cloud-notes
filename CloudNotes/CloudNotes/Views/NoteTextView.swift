//
//  NoteTextView.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/09.
//

import UIKit

final class NoteTextView: UITextView {
    weak var noteListViewControllerDelegate: NoteListViewControllerDelegate?
}

extension NoteTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        noteListViewControllerDelegate?.applyTextUpdate(with: textView.text)
        noteListViewControllerDelegate?.applySnapshot(animatingDifferences: false)
        noteListViewControllerDelegate?.listCollectionView?.selectItem(at: NoteListViewController.NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
    }
}
