//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit

final class NoteDetailViewController: UIViewController {
    // MARK: - Properties
    private var note: Note?
    
    // MARK: - UI Elements
    var noteTextView: UITextView = {
        let noteTextView = UITextView()
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
        noteTextView.adjustsFontForContentSizeCategory = true
        return noteTextView
    }()
    
    // MARK: - Namespaces
    private enum ViewContents {
        /// shows when the screen first loaded with regular size class.
        static let welcomeGreeting = "환영합니다!"
        static let newLineString = "\n"
        static let emptyString = ""
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor(to: .systemBackground)
        configureTextView()
        updateUI()
    }
}

// MARK: - Configure Detail Note View
extension NoteDetailViewController {
    func setContent(with inputNote: Note) {
        note = inputNote
    }
    
    private func setBackgroundColor(to color: UIColor) {
        view.backgroundColor = color
    }
    
    private func configureTextView() {
        view.addSubview(noteTextView)
        
        noteTextView.clipsToBounds = false
        noteTextView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    func updateUI() {
        guard let note = note else {
            noteTextView.text = ViewContents.welcomeGreeting
            return
        }
        
        noteTextView.text = ViewContents.emptyString
        noteTextView.insertText(note.title + ViewContents.newLineString)
        noteTextView.insertText(note.body)
    }
}
