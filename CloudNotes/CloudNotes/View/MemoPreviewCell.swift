//
//  MemoPreviewCell.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/05/31.
//

import UIKit

class MemoPreviewCell: UITableViewCell {
    static let reusableIdentifier = "memoPreviewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.text = "titleLabel"
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "dateLabel"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let previewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "previewDescription"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        addSubviews()
        addCellItemCosntratins()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setTextValues(title: String, date: Double, description: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"

        titleLabel.text = title
        dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: date))
        previewDescriptionLabel.text = description
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(previewDescriptionLabel)
    }

    private func addCellItemCosntratins() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            previewDescriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            previewDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            previewDescriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }
}
