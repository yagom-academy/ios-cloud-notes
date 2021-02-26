//
//  DetailNoteViewController.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/18.
//

import UIKit

class DetailNoteViewController: UIViewController {
    static let memoDidSave = Notification.Name(rawValue: "memoDidSave")
    
    var fetchedNote: Note?
    let detailNoteTextView = UITextView()
    let completeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpCompleteButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureTextView()
        setTextViewFromFetchedNote()
    }
    
    private func configureTextView() {
        addTapGestureRecognizerToTextView()
        detailNoteTextView.delegate = self
        detailNoteTextView.isEditable = false
        detailNoteTextView.dataDetectorTypes = .all
        detailNoteTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailNoteTextView)
        detailNoteTextView.font = .preferredFont(forTextStyle: .body)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            detailNoteTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            detailNoteTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            detailNoteTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            detailNoteTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setTextViewFromFetchedNote() {
        guard let noteData = fetchedNote else {
            return
        }
        
        detailNoteTextView.text = "\(noteData.title)\n\(noteData.body)"
    }
    
    @objc private func touchUpCompleteButton() {
        detailNoteTextView.isEditable = false
        saveNote()
        if let _ = navigationController?.presentingViewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addTapGestureRecognizerToTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTextViewEditableState))
        detailNoteTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func changeTextViewEditableState() {
        detailNoteTextView.isEditable.toggle()
        if detailNoteTextView.isEditable {
            detailNoteTextView.becomeFirstResponder()
        } else {
            saveNote()
        }
    }
    
    private func saveNote() {
        let note: Note
        if detailNoteTextView.text == UIConstants.strings.textInitalizing {
            note = Note(title: UIConstants.strings.emptyNoteTitleText, body: UIConstants.strings.textInitalizing)
        } else {
            let textViewText = detailNoteTextView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
            note = checkTextView(text: textViewText)
        }
        
        if let fetchedNote = self.fetchedNote {
            fetchedNote.title = note.title
            fetchedNote.body = note.body
            fetchedNote.lastModifiedDate = note.lastModifiedDate
        } else {
            NoteData.shared.noteLists.append(note)
            self.fetchedNote = note
        }
        
        NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
    }
    
    private func checkTextView(text: [String.SubSequence]) -> Note {
        if text.count == 1 {
            let titleText = String(text[0])
            let note = Note(title: titleText, body: UIConstants.strings.textInitalizing)
            return note
        } else {
            let titleText = String(text[0])
            let bodyText = String(text[1])
            let note = Note(title: titleText, body: bodyText)
            return note
        }
    }
}

extension DetailNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = nil
    }
}
