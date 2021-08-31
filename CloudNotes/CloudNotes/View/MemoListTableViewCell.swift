//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier = "memoListTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLables()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.textColor = .black
        bodyLabel.textAlignment = .left
        bodyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        return bodyLabel
    }()
    
    private let lastModifiedLabel: UILabel = {
        let lastModifiedLabel = UILabel()
        lastModifiedLabel.font = UIFont.preferredFont(forTextStyle: .body)
        lastModifiedLabel.textColor = .black
        lastModifiedLabel.textAlignment = .left
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        return lastModifiedLabel
    }()
}

extension MemoListTableViewCell {
    func configureLables() {
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.addArrangedSubview(lastModifiedLabel)
        horizontalStackView.addArrangedSubview(bodyLabel)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStackView)
        
        horizontalStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 20).isActive = true
    }
}
