//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class MemoListCell: UITableViewCell {
    static let identifier: String = "MemoListCell"
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return dateLabel
    }()
    lazy var predescriptionLabel: UILabel = {
        let predescriptionLabel = UILabel()
        predescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        predescriptionLabel.font = .preferredFont(forTextStyle: .body)
        predescriptionLabel.adjustsFontForContentSizeCategory = true
        predescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        predescriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return predescriptionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(predescriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            predescriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            predescriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 50),
            predescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
