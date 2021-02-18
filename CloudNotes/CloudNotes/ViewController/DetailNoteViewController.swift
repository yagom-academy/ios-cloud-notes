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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTextView()
        configureNavigationItem()
    }
    
    private func configureTextView() {
        addTapGestureRecognizerToTextView()
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
    
    private func configureNavigationItem() {
        let completeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(touchUpCompleteButton))
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    @objc func touchUpCompleteButton() {
        detailNoteTextView.isEditable = false
    }
    
    private func addTapGestureRecognizerToTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeTextViewEditableState))
        detailNoteTextView.isEditable = false
        detailNoteTextView.dataDetectorTypes = .all
        detailNoteTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc func changeTextViewEditableState() {
        detailNoteTextView.isEditable = true
        detailNoteTextView.becomeFirstResponder()
    }
}
