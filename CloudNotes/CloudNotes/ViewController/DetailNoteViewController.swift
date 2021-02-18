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

extension DetailNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = completeButton
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = nil
    }
}
