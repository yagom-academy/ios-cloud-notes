//
//  TableCell.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/04.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    // MARK: - property
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        let priority = UILayoutPriority(1000)
        label.setContentCompressionResistancePriority(priority, for: .horizontal)
        return label
    }()

    private lazy var firstLineOfContentLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textColor = .systemGray
        return label
    }()

    // MARK: - initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellComponent()
        addConstraintCellComponent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MemoListTableViewCell {
    // MARK: - Method
    private func configureCellComponent() {
        backgroundColor = .systemBackground
        self.accessoryType = .disclosureIndicator
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(firstLineOfContentLabel)
    }

    private func addConstraintCellComponent() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        firstLineOfContentLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)

        let margin = contentView.layoutMarginsGuide
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor)
        let titleLabelTarailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor)

        let dateLabelTopConstraint = dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        let dateLabelLeadingConstraint = dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        let dateLabelBottomConstraint = dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)

        let firstLineOfContentLabelTopConstraint = firstLineOfContentLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor)
        let firstLineOfContentLabelLeadingConstraint = firstLineOfContentLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 30)
        let firstLineOfContentLabelTrailingConstraint = firstLineOfContentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        let firstLineOfContentLabelBottomConstraint = firstLineOfContentLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor)

        NSLayoutConstraint.activate([
            titleLabelTopConstraint,
            titleLabelLeadingConstraint,
            titleLabelTarailingConstraint,
            dateLabelTopConstraint,
            dateLabelLeadingConstraint,
            dateLabelBottomConstraint,
            firstLineOfContentLabelTopConstraint,
            firstLineOfContentLabelTrailingConstraint,
            firstLineOfContentLabelLeadingConstraint,
            firstLineOfContentLabelBottomConstraint
        ])
    }

    func configure(title: String, content: String, date: String) {
        self.titleLabel.text = title
        self.dateLabel.text = date
        self.firstLineOfContentLabel.text = content
    }
}
