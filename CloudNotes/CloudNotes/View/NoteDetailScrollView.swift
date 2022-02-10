//
//  NoteScrollView.swift
//  CloudNotes
//
//  Created by 서녕 on 2022/02/08.
//

import UIKit

class NoteDetailScrollView: UIScrollView {
    private let noteDetailStackView = UIStackView()
    private(set) var lastModifiedDateLabel = UILabel()
    private(set) var noteDetailTextView = UITextView()
    
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
    
    func setupConstraint(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
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
            noteDetailStackView.topAnchor.constraint(equalTo: topAnchor),
            noteDetailStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            noteDetailStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteDetailStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noteDetailStackView.widthAnchor.constraint(equalTo: widthAnchor),
            noteDetailStackView.heightAnchor.constraint(equalTo: heightAnchor)
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
    
    func configure(with noteInformation: NoteInformation) {
        lastModifiedDateLabel.text = noteInformation.localizedDateString
        noteDetailTextView.text = noteInformation.content
    }
}
