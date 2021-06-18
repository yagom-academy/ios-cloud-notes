//
//  NoteListTableViewCell.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/01.
//

import UIKit

final class NoteListTableViewCell: UITableViewCell {
    static let identifier = "NoteListTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private var previewBodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, previewBodyLabel])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var noteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionStackView])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureConstraint() {
        noteStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(noteStackView)
        
        NSLayoutConstraint.activate([
            noteStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            noteStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            noteStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            noteStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configure(_ note: NoteData) {
        self.titleLabel.text = note.title == NoteLiteral.empty ? NoteLiteral.defaultTitle : note.title
        self.dateLabel.text = NoteListViewModel.dateFormatter.string(from: note.lastModifiedDate ?? Date())
        self.previewBodyLabel.text = note.body == NoteLiteral.empty ? NoteLiteral.defaultBody : note.body
    }
    
    func update(title: String, date: Date, body: String) {
        self.titleLabel.text = title
        self.dateLabel.text = NoteListViewModel.dateFormatter.string(from: date)
        self.previewBodyLabel.text = body
    }
}
