//
//  ItemListViewCell.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class ItemListViewCell: UITableViewCell {
    static let identifier = "ItemListViewCell"

    lazy var titleLabel = createdTitleLabel()
    lazy var dateLabel = createdDateLabel()
    lazy var descriptionLabel = createdDescriptionLabel()

    private let dateFormatter = DateFormatter()
    private let half: CGFloat = 0.5

    var data: Memo?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = AccessoryType.disclosureIndicator

        dateFormatter.dateFormat = "yyyy.MM.dd."
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with memo: Memo) {
        data = memo
        let lastedUpdatedTime = Date(timeIntervalSince1970: memo.lastUpdatedTime)

        titleLabel.text = memo.title
        descriptionLabel.text = memo.description
        dateLabel.text = dateFormatter.string(from: lastedUpdatedTime)
    }

}

extension ItemListViewCell {

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

        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: half).isActive = true

        return label
    }

    private func createdDateLabel() -> UILabel {
        let label = baseLabel
        let thirtyHalfPercent: CGFloat = 0.35

        label.accessibilityLabel = "날짜 : "

        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: thirtyHalfPercent).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: half).isActive = true

        return label
    }

    private func createdDescriptionLabel() -> UILabel {
        let label = baseLabel
        let sixtyHalfPercent: CGFloat = 0.65

        label.accessibilityLabel = "내용 : "
        label.textColor = .gray

        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: sixtyHalfPercent).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: half).isActive = true

        return label
    }
}
