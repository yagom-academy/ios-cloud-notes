//
//  MemoPreviewCell.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/05/31.
//

import UIKit
import CoreData

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
        setUpTitleLabel()
        setUpDateLabel()
        setUpPreviewDescriptionLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func fetchData(sampleMemo: SampleMemo) {
        titleLabel.text = sampleMemo.title
        dateLabel.text = formatDate(date: sampleMemo.lastModifiedDate)
        previewDescriptionLabel.text = sampleMemo.description
    }

    private func setUpTitleLabel() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
        ])
    }

    private func setUpDateLabel() {
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    private func setUpPreviewDescriptionLabel() {
        contentView.addSubview(previewDescriptionLabel)

        NSLayoutConstraint.activate([
            previewDescriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            previewDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            previewDescriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }

    private func formatDate(date: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter.string(from: Date(timeIntervalSince1970: date))
    }
}
