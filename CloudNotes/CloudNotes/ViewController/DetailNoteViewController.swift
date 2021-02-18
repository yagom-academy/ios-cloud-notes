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
    }
    
    private func configureTextView() {
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
}
