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
        configureDescriptionStackView()
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
        lastModifiedLabel.textAlignment = .right
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        return lastModifiedLabel
    }()
}

extension MemoListTableViewCell {
    private enum NameSpace {
        enum DescriptionStackView {
            static let spacing: CGFloat = 30
            static let topAnchorConstant: CGFloat = 10
            static let leadingAnchorConstant: CGFloat = 10
            static let trailingAnchorConstant: CGFloat = 10
            static let bottomAnchorConstant: CGFloat = 30
        }
    }
}

extension MemoListTableViewCell {
    func configureDescriptionStackView() {
        let descriptionStackView = UIStackView(arrangedSubviews: [lastModifiedLabel, bodyLabel])
        descriptionStackView.axis = .horizontal
        descriptionStackView.alignment = .fill
        descriptionStackView.distribution = .equalSpacing
        descriptionStackView.spacing = NameSpace.DescriptionStackView.spacing
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionStackView)
        
        descriptionStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: NameSpace.DescriptionStackView.topAnchorConstant).isActive = true
        descriptionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NameSpace.DescriptionStackView.leadingAnchorConstant).isActive = true
        descriptionStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: NameSpace.DescriptionStackView.trailingAnchorConstant).isActive = true
        descriptionStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: NameSpace.DescriptionStackView.bottomAnchorConstant).isActive = true
    }
    
    func configure(with memoItem: Memo) {
        bodyLabel.text = memoItem.body
        lastModifiedLabel.text = String(memoItem.lastModified)
    }
}
