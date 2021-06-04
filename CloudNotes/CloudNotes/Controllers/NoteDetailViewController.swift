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
    
    private enum Constraints {
        static let scrollIndicatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        
        enum NoteTextView {
            static let leading: CGFloat = 30
            static let trailing: CGFloat = -30
            static let top: CGFloat = 50
            static let bottom: CGFloat = -50
        }
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
    
    private func configureScrollIndicatorInsets(of textView: UITextView) {
        textView.clipsToBounds = false
        textView.scrollIndicatorInsets = Constraints.scrollIndicatorInset
    }
    
    private func configureTextView() {
        view.addSubview(noteTextView)
        configureScrollIndicatorInsets(of: noteTextView)
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constraints.NoteTextView.leading
            ),
            noteTextView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constraints.NoteTextView.trailing
            ),
            noteTextView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constraints.NoteTextView.top
            ),
            noteTextView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: Constraints.NoteTextView.bottom
            )
        ])
    }
    
    private func setGreetingText(to textView: UITextView) {
        textView.text = ViewContents.welcomeGreeting
    }
    
    private func setText(to textView: UITextView, with note: Note) {
        textView.text = ViewContents.emptyString
        textView.insertText(note.title + ViewContents.newLineString)
        textView.insertText(note.body)
    }
    
    func updateUI() {
        guard let note = note else {
            setGreetingText(to: noteTextView)
            return
        }
        
        setText(to: noteTextView, with: note)
    }
}
