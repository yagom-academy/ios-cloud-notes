//
//  MemoListViewCell.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class MemoListViewCell: UITableViewCell {
    static let identifier = "MemoListViewCell"

    private var titleLabel: UILabel?
    private var dateLabel: UILabel?
    private var descriptionLabel: UILabel?

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

        titleLabel?.text = memo.title
        descriptionLabel?.text = memo.description
        dateLabel?.text = dateFormatter.string(from: lastedUpdatedTime)
    }

}

// MARK: - Draw View
extension MemoListViewCell {
    private var baseLabel: UILabel {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .left

        contentView.addSubview(label)

        return label
    }

    private func createdStackView(
        insertedAt superView: UIView? = nil,
        with contents: UIView?...,
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        distribution: UIStackView.Distribution,
        alignment: UIStackView.Alignment
    ) -> UIStackView {
        let optionalUnwrappedContents = contents.compactMap { $0 }
        let stackView = UIStackView(arrangedSubviews: optionalUnwrappedContents)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = alignment

        if let superView = superView {
            superView.addSubview(stackView)
        }

        return stackView
    }

    private func configureLayout() {
        titleLabel = baseLabel
        dateLabel = baseLabel
        descriptionLabel = baseLabel

        titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        dateLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        dateLabel?.setContentHuggingPriority(.required, for: .horizontal)

        let hStackView = createdStackView(
            with: dateLabel, descriptionLabel,
            axis: .horizontal,
            spacing: 12,
            distribution: .fillProportionally,
            alignment: .fill
        )

        let vStackView = createdStackView(
            insertedAt: contentView,
            with: titleLabel, hStackView,
            axis: .vertical,
            spacing: 6,
            distribution: .fill,
            alignment: .fill
        )

        contentView.addSubview(vStackView)

        vStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
