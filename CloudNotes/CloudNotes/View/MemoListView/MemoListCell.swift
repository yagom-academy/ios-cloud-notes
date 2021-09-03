//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import UIKit

class MemoListCell: UITableViewCell {
    static let reuseIdentifier = "\(MemoListCell.self)"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with memo: MemoPresentModel) {
        self.titleLabel.text = memo.title
        self.dateLabel.text = memo.date
        self.bodyLabel.text = memo.body
    }
}

// MARK: - Layout
extension MemoListCell {
    private enum Constraint {
        enum TitleLabel {
            static let leadingConstant: CGFloat = 5
            static let trailingConstant: CGFloat = 5
            static let topConstant: CGFloat = 5
        }
        enum DateLabel {
            static let bottomConstant: CGFloat = -10
            static let trailingConstant: CGFloat = 5
        }
        enum BodyLabel {
            static let leadingConstant: CGFloat = 5
            static let trailingConstant: CGFloat = -5
        }
    }

    private func setupUI() {
        contentView.addSubviews(titleLabel, bodyLabel, dateLabel)

        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        var cellConstraints: [NSLayoutConstraint] = []
        let titleLabelConstraints = [titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                                         constant: Constraint.TitleLabel.leadingConstant),
                                     titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                                          constant: Constraint.TitleLabel.trailingConstant),
                                     titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                                     constant: Constraint.TitleLabel.topConstant),
                                     titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor)]

        let dateLabelConstraints = [dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                    dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                      constant: Constraint.DateLabel.bottomConstant)]

        let bodyLabelConstraints = [bodyLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor,
                                                                       constant: Constraint.BodyLabel.leadingConstant),
                                    bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                                        constant: Constraint.BodyLabel.trailingConstant),
                                    bodyLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor)]

        cellConstraints.append(contentsOf: titleLabelConstraints)
        cellConstraints.append(contentsOf: dateLabelConstraints)
        cellConstraints.append(contentsOf: bodyLabelConstraints)

        NSLayoutConstraint.activate(cellConstraints)
    }
}
