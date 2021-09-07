//
//  MemoListViewCell.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class MemoListViewCell: UITableViewCell {
    static let identifier = "MemoListViewCell"

    private lazy var titleLabel = createdTitleLabel()
    private lazy var dateLabel = createdDateLabel()
    private lazy var descriptionLabel = createdDescriptionLabel()

    private let dateFormatter = DateFormatter()
    private let half: CGFloat = 0.5

    var data: Memo?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = AccessoryType.disclosureIndicator

        dateFormatter.dateFormat = "yyyy.MM.dd."
    }

    required init?(coder: NSCoder) {
        fatalError("Error: Cell is created on wrong way")
    }

    func configure(with memo: Memo) {
        data = memo
        let lastedUpdatedTime = Date(timeIntervalSince1970: memo.lastUpdatedTime)

        titleLabel.text = memo.title
        descriptionLabel.text = memo.description
        dateLabel.text = dateFormatter.string(from: lastedUpdatedTime)
    }

}

// MARK: - Draw View
extension MemoListViewCell {

    private var baseLabel: UILabel {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left

        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        return label
    }

    private func createdTitleLabel() -> UILabel {
        let label = baseLabel
        label.font = UIFont.preferredFont(forTextStyle: .title2)

        label.accessibilityLabel = "제목 : "

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: half)
        ])

        return label
    }

    private func createdDateLabel() -> UILabel {
        let label = baseLabel
        let thirtyHalfPercent: CGFloat = 0.35

        label.accessibilityLabel = "날짜 : "

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            label.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: thirtyHalfPercent),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: half)
        ])

        return label
    }

    private func createdDescriptionLabel() -> UILabel {
        let label = baseLabel
        let sixtyHalfPercent: CGFloat = 0.65

        label.accessibilityLabel = "내용 : "
        label.textColor = .gray

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            label.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: sixtyHalfPercent),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: half)
        ])

        return label
    }
}
