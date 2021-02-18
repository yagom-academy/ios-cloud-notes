//
//  NewNoteViewController.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/17.
//

import UIKit

class NewNoteViewController: UIViewController {
    private let noteTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTextView()
        configureNavigationItem()
    }
    
    private func configureTextView() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteTextView)
        noteTextView.font = .preferredFont(forTextStyle: .body)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func configureNavigationItem() {
        let completeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpCompleteButton))
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    @objc func touchUpCompleteButton() {
        if let textViewText = noteTextView.text, textViewText == "" {
            let titleText = "제목 없음"
            let bodyText = ""
            let lastModifiedDate = Date()
            let note = Note(title: titleText, body: bodyText, lastModifiedDate: lastModifiedDate)
            NoteData.shared.noteLists.append(note)
        } else {
            let textViewText = noteTextView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: true)
            let titleText = String(textViewText[0])
            let bodyText = String(textViewText[1])
            let lastModifiedDate = Date()
            let note = Note(title: titleText, body: bodyText, lastModifiedDate: lastModifiedDate)
            NoteData.shared.noteLists.append(note)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
