//
//  DetailNoteViewController.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/18.
//

import UIKit

class DetailNoteViewController: UIViewController {
    var fetchedNoteData: Note?
    let detailNoteTextView = UITextView()
    let completeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpCompleteButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTextView()
    }
    
    private func configureTextView() {
        addTapGestureRecognizerToTextView()
        detailNoteTextView.delegate = self
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
        
        guard let noteData = fetchedNoteData else {
            return
        }
        detailNoteTextView.text = "\(noteData.title)\n\(noteData.body)"
    }
    
    @objc func touchUpCompleteButton() {
        detailNoteTextView.isEditable = false
        
        saveNoteDate()
        
        if let _ = navigationController?.presentingViewController {
            self.navigationController?.popViewController(animated: true)
        }
        
        if let noteViewController = splitViewController?.viewControllers.first as? NoteViewController {
            noteViewController.reloadTableView()
        }
    }
    
    private func addTapGestureRecognizerToTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTextViewEditableState))
        detailNoteTextView.isEditable = false
        detailNoteTextView.dataDetectorTypes = .all
        detailNoteTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc func changeTextViewEditableState() {
        detailNoteTextView.isEditable.toggle()
        if detailNoteTextView.isEditable {
            detailNoteTextView.becomeFirstResponder()
        } else {
            saveNoteDate()
        }
    }
    
    func saveNoteDate() {
        if let textViewText = detailNoteTextView.text, textViewText == "" {
            let titleText = "제목 없음"
            let bodyText = ""
            let note = Note(title: titleText, body: bodyText)
            NoteData.shared.noteLists.append(note)
        } else {
            let textViewText = detailNoteTextView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
            if textViewText.count == 1 {
                let titleText = String(textViewText[0])
                let note = Note(title: titleText, body: "")
                NoteData.shared.noteLists.append(note)
            } else {
                let titleText = String(textViewText[0])
                let bodyText = String(textViewText[1])
                let note = Note(title: titleText, body: bodyText)
                NoteData.shared.noteLists.append(note)
            }
        }
  
        if
            let navi = splitViewController?.viewControllers.first as? UINavigationController,
            let noteViewController = navi.viewControllers.first as? NoteViewController {
            noteViewController.reloadTableView()
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
