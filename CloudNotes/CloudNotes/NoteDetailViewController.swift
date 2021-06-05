//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/03.
//

import UIKit

final class NoteDetailViewController: UIViewController {
    private let detailNoteTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.textAlignment = .left
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = .systemBackground
        textView.isSelectable = true
        textView.isEditable = true
        textView.contentOffset = CGPoint(x: 0, y: -20)
        textView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        view.backgroundColor = .systemBackground
        setConstraint()
    }
    
    private func setConstraint() {
        detailNoteTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailNoteTextView)
        
        NSLayoutConstraint.activate([
            detailNoteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailNoteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailNoteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailNoteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureTextView(_ note: NoteData) {
        self.detailNoteTextView.text = note.title + "\n\n" + note.body
    }

}
