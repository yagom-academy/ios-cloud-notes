//
//  NotesTableViewCell.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/15.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        return titleLabel
    }()
    let lastModifiedDateLabel: UILabel = {
        let lastModifiedDateLabel = UILabel()
        lastModifiedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedDateLabel.font = .preferredFont(forTextStyle: .caption1)
        return lastModifiedDateLabel
    }()
    let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = .preferredFont(forTextStyle: .caption1)
        bodyLabel.textColor = .gray
        return bodyLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureConstraints()
    }
    
    private func configureConstraints() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(lastModifiedDateLabel)
        self.contentView.addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            lastModifiedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            lastModifiedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            bodyLabel.centerYAnchor.constraint(equalTo: lastModifiedDateLabel.centerYAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: lastModifiedDateLabel.trailingAnchor, constant: 40),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        lastModifiedDateLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        lastModifiedDateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        lastModifiedDateLabel.text = ""
        bodyLabel.text = ""
        bodyLabel.textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
