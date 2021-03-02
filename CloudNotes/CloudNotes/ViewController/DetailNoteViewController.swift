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
    private let detailNoteTextView = UITextView()
    private let completeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpCompleteButton))
    private let moreButton: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(touchUpCompleteButton))
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        configureTextView()
        setTextViewFromFetchedNote()
    }
    
    private func configureTextView() {
        addTapGestureRecognizerToTextView()
        detailNoteTextView.delegate = self
        if let _ = fetchedNote {
            detailNoteTextView.isEditable = false
        } else {
            detailNoteTextView.isEditable = true
            detailNoteTextView.becomeFirstResponder()
        }
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
        guard let note = fetchedNote, let title = note.title, let body = note.body else {
            return
        }
        
        detailNoteTextView.text = "\(title)\n\(body)"
    }
    
    @objc private func touchUpCompleteButton() {
        detailNoteTextView.isEditable = false
        saveNote()
        if let _ = navigationController?.presentingViewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func touchUpMoreButton() {
        // 다음 스텝에서 구현
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
        let note: (title: String, body: String)
        note = divdeTextForNote(text: detailNoteTextView.text)
        
        if let fetchedNote = self.fetchedNote {
            if (fetchedNote.title != note.title)
                || (fetchedNote.body != note.body) {
                fetchedNote.title = note.title
                fetchedNote.body = note.body
                fetchedNote.lastModifiedDate = Date()
                CoreDataManager.shared.saveContext()
            }
        } else {
            self.fetchedNote = CoreDataManager.shared.createNote(title: note.title, body: note.body)
        }
        
        NotificationCenter.default.post(name: DetailNoteViewController.memoDidSave, object: nil)
    }
    
    private func divdeTextForNote(text: String) -> (title: String, body: String) {
        let note: (title: String, body: String)
        
        guard text != UIConstants.strings.textInitalizing else {
            note.title = UIConstants.strings.emptyNoteTitleText
            note.body = UIConstants.strings.textInitalizing
            return note
        }
        
        let splitedText = detailNoteTextView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
        if splitedText.count == 1 {
            note.title = String(splitedText[0])
            note.body = UIConstants.strings.textInitalizing
        } else {
            note.title = String(splitedText[0])
            note.body = String(splitedText[1])
        }
        
        return note
    }
}

extension DetailNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.setRightBarButton(completeButton, animated: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.setRightBarButton(moreButton, animated: false)
    }
}
