//
//  NoteListCellTableViewCell.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteListCell: UITableViewCell {
    var noteData: Note? {
        didSet {
            displayData()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.lineBreakStrategy = .hangulWordPriority
        title.numberOfLines = 1
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        return title
    }()
    
    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.setContentCompressionResistancePriority(.required, for: .horizontal)
        date.font = UIFont.preferredFont(forTextStyle: .headline)
        return date
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = UIColor.lightGray
        description.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
        self.accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func displayData() {
        guard let data = noteData else { return }
        titleLabel.text = data.title
        dateLabel.text = data.date
        descriptionLabel.text = data.description
    }
    
    private func setConstraint() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
 
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            dateLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
}
