//
//  NoteDetailViewController.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit
import OSLog

final class NoteDetailViewController: UIViewController {
    // MARK: - Properties
    private var note: Note?
    
    // MARK: - UI Elements
    private var noteTextView: NoteTextView = {
        let noteTextView = NoteTextView()
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.font = UIFont.preferredFont(forTextStyle: .body)
        noteTextView.adjustsFontForContentSizeCategory = true
        return noteTextView
    }()
    
    // MARK: - Namespaces
    private enum ViewContents {
        /// shows when the screen first loaded with regular size class.
        static let welcomeGreeting = "환영합니다!"
        static let titleSeparatorString = "\n"
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
        configureViews()
        updateTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.isEditable = false
        moveTop(of: noteTextView)
        setTextViewDelegatesIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextView.isEditable = true
    }
    
    // MARK: - Configure Detail Note View
    private func configureViews() {
        configureNavigationBar()
        configureTextView()
        setNoteBackgroundColor(to: .systemBackground)
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
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.NoteTextView.leading),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraints.NoteTextView.trailing),
            noteTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constraints.NoteTextView.top),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constraints.NoteTextView.bottom)
        ])
    }
    
    private func setGreetingText(to textView: UITextView) {
        textView.text = ViewContents.welcomeGreeting
    }
    
    private func setText(to textView: UITextView, with note: Note) {
        textView.text = note.title + ViewContents.titleSeparatorString + note.body
    }
    
    private func moveTop(of textView: UITextView) {
        textView.setContentOffset(CGPoint(x: .zero, y: -view.safeAreaInsets.top), animated: false)
    }
    
    private func updateTextView() {
        if let note = note {
            setText(to: noteTextView, with: note)
            return
        }
        
        setGreetingText(to: noteTextView)
        noteTextView.isEditable = false
    }
    
    private func removeActivatedKeyboard() {
        noteTextView.resignFirstResponder()
    }
    
    private func setTextViewDelegatesIfNeeded() {
        guard noteTextView.delegate == nil && noteTextView.noteListViewControllerDelegate == nil else {
            return
        }
        
        noteTextView.delegate = noteTextView
        
        guard let noteListViewController = splitViewController?.viewController(for: .primary) as? NoteListViewController else {
            os_log(.error, log: .ui, OSLog.objectCFormatSpecifier, UIError.downcastingFailed(subject: "NoteListViewController", location: #function).localizedDescription)
            return
        }
        noteTextView.noteListViewControllerDelegate = noteListViewController
    }
    
    // MARK: - Configure Navigation Bar and Relevant Actions
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: NavigationBarItems.rightButtonImage, style: .plain, target: self, action: #selector(ellipsisTapped))
    }

    @objc private func ellipsisTapped() { }
}

extension NoteDetailViewController: NoteDetailViewControllerDelegate {
    func showNote(with note: Note) {
        self.note = note
        updateTextView()
        moveTop(of: noteTextView)
        removeActivatedKeyboard()
    }
}
