//
//  NoteListTableViewCell.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/01.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    static let identifier = "NoteListTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    let previewBodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        return label
    }()
    
    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, previewBodyLabel])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var outerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, innerStackView])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setConstraint() {
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configure(_ note: NoteData) {
        self.titleLabel.text = note.title
        self.dateLabel.text = note.formattedLastModified
        self.previewBodyLabel.text = note.body
    }
}
