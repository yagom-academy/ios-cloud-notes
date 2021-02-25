//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by 강인희 on 2021/02/16.
//

import UIKit

class MemoListCell: UITableViewCell {
    static let identifier = String(describing: MemoListCell.self)
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return titleLabel
    }()
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return dateLabel
    }()
    lazy var predescriptionLabel: UILabel = {
        let predescriptionLabel = UILabel()
        predescriptionLabel.font = .preferredFont(forTextStyle: .body)
        predescriptionLabel.adjustsFontForContentSizeCategory = true
        predescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        predescriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return predescriptionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        dateLabel.text = ""
        predescriptionLabel.text = ""
    }
    
    private func setUpConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(predescriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        predescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            predescriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 50),
            predescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            predescriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor)
        ])
    }
}
