//
//  NoteScrollView.swift
//  CloudNotes
//
//  Created by 서녕 on 2022/02/08.
//

import UIKit

final class NoteDetailScrollView: UIScrollView {
    
    // MARK: - properties
    
    private let noteDetailStackView = UIStackView()
    private(set) var lastModifiedDateLabel = UILabel()
    private(set) var noteDetailTextView = UITextView()
    
    // MARK: - init Method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupStackViewConstraint()
        setupLastModifiedDateLabel()
        setupNoteDetailTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal Methods
    
    func setupConstraint(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configure(with note: Note) {
        guard let title = note.title,
              let content = note.content else {
                  return
              }
        if title == "" && content == "" {
            self.noteDetailTextView.text = ""
            DispatchQueue.main.async {
                let position = self.noteDetailTextView.beginningOfDocument
                self.noteDetailTextView.selectedTextRange = self.noteDetailTextView.textRange(
                                                                                from: position,
                                                                                to: position)
                self.noteDetailTextView.becomeFirstResponder()
            }
        } else {
            let attributedString = NSMutableAttributedString()
                .preferredFont(string: title + "\n", forTextStyle: .title1)
                .preferredFont(string: content, forTextStyle: .body)
            attributedString.color(to: .label)
            DispatchQueue.main.async {
                self.noteDetailTextView.attributedText = attributedString
            }
        }
        self.lastModifiedDateLabel.text = note.localizedDateString
    }
    
    // MARK: - private Methods
    
    private func setupStackView() {
        addSubview(noteDetailStackView)
        noteDetailStackView.axis = .vertical
        noteDetailStackView.alignment = .fill
        noteDetailStackView.spacing = 10
        noteDetailStackView.addArrangedSubview(lastModifiedDateLabel)
        noteDetailStackView.addArrangedSubview(noteDetailTextView)
    }
    
    private func setupStackViewConstraint() {
        noteDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteDetailStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            noteDetailStackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            noteDetailStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            noteDetailStackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            noteDetailStackView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),
            noteDetailStackView.heightAnchor.constraint(greaterThanOrEqualTo: frameLayoutGuide.heightAnchor)
        ])
    }
    
    private func setupLastModifiedDateLabel() {
        lastModifiedDateLabel.setContentHuggingPriority(
            .required,
            for: .vertical
        )
        lastModifiedDateLabel.textAlignment = .center
        lastModifiedDateLabel.font = .preferredFont(forTextStyle: .caption1)
    }
    
    private func setupNoteDetailTextView() {
        noteDetailTextView.isScrollEnabled = false
        noteDetailTextView.font = .preferredFont(forTextStyle: .body)
        let inset: CGFloat = 10
        noteDetailTextView.textContainerInset = UIEdgeInsets(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
    }
}

private extension NSMutableAttributedString {
    func preferredFont(
        string: String,
        forTextStyle: UIFont.TextStyle
    ) -> NSMutableAttributedString {
        let attributeFont: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: forTextStyle)]
        self.append(NSAttributedString(string: string, attributes: attributeFont))
        return self
    }
    
    func color(to color: UIColor) {
        let range = NSRange(0..<self.length)
        self.addAttribute(.foregroundColor, value: color, range: range)
    }
}
