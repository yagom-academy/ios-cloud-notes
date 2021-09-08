//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    // MARK: Property
    static let identifier = "memoListTableViewCell"
    
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
        bodyLabel.textColor = .systemGray
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
    
    private let descriptionStackView: UIStackView = {
        let descriptionStackView = UIStackView()
        descriptionStackView.axis = .horizontal
        descriptionStackView.alignment = .fill
        descriptionStackView.distribution = .equalSpacing
        descriptionStackView.spacing = NameSpace.DescriptionStackView.spacing
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionStackView
    }()
    
    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        containerStackView.spacing = NameSpace.ContainerStackView.spacing
        containerStackView.alignment = .fill
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        return containerStackView
    }()
    
    // MARK: initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(containerStackView)
        configureContainerStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: NameSpace
extension MemoListTableViewCell {
    private enum NameSpace {
        enum DescriptionStackView {
            static let spacing: CGFloat = 30
        }
        
        enum ContainerStackView {
            static let spacing: CGFloat = 8
        }
    }
}

// MARK: Setup
extension MemoListTableViewCell {
    private func configureContainerStackView() {
        descriptionStackView.addArrangedSubview(lastModifiedLabel)
        descriptionStackView.addArrangedSubview(bodyLabel)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configure(with memoItem: Memo) {
        titleLabel.text = memoItem.title
        bodyLabel.text = memoItem.body
        lastModifiedLabel.text = DateFormatter.localizedString(of: memoItem.lastModified)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        bodyLabel.text = nil
        lastModifiedLabel.text = nil
    }
}
