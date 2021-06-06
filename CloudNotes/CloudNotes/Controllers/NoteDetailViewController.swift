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
    
    private enum NavigationBarItems {
        static let rightButtonImage = UIImage(systemName: "ellipsis.circle")
    }
    
    private enum Constraints {
        static let scrollIndicatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        
        enum NoteTextView {
            static let leading: CGFloat = 30
            static let trailing: CGFloat = -30
            static let top: CGFloat = 0
            static let bottom: CGFloat = 0
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTextView()
        setNoteBackgroundColor(to: .systemBackground)
        updateTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noteTextView.isEditable = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        noteTextView.isEditable = true
    }
}

// MARK: - Configure Detail Note View
extension NoteDetailViewController {
    func showContent(with inputNote: Note) {
        note = inputNote
        updateTextView()
        moveTop(of: noteTextView)
        removeActivatedKeyboard()
    }
    
    private func setNoteBackgroundColor(to color: UIColor) {
        view.backgroundColor = color
        noteTextView.backgroundColor = color
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
    
    private func moveTop(of textView: UITextView) {
        textView.setContentOffset(CGPoint(x: 0, y: -view.safeAreaInsets.top), animated: false)
    }
    
    private func updateTextView() {
        if let note = note {
            setText(to: noteTextView, with: note)
        } else {
            setGreetingText(to: noteTextView)
        }
    }
    
    private func removeActivatedKeyboard() {
        noteTextView.resignFirstResponder()
    }
}

// MARK: - Configure Navigation Bar and Relevant Actions
extension NoteDetailViewController {
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: NavigationBarItems.rightButtonImage,
            style: .plain,
            target: self,
            action: #selector(ellipsisTapped)
        )
    }

    @objc private func ellipsisTapped() { }
}
