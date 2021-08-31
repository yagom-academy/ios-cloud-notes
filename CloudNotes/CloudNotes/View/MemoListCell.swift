//
//  memoListCell.swift
//  CloudNotes
//
//  Created by Luyan on 2021/08/31.
//

import UIKit

class MemoListCell: UITableViewCell {
    static let reuseIdentifier = "\(MemoListCell.self)"

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    var bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    var dateLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setConstrains()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with memo: MemoPresentModel) {
        self.titleLabel.text = memo.title
        self.dateLabel.text = "\(memo.date)"
        self.bodyLabel.text = memo.body
    }
}

// MARK: - Layout
extension MemoListCell {
    private func setConstrains() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(dateLabel)

        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        var cellConstraints: [NSLayoutConstraint] = []
        let titleLabelConstraints = [titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                                     titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                                     titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor)]

        let dateLabelConstraints = [dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                    dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)]

        let bodyLabelConstraints = [bodyLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 30),
                                    bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
                                    bodyLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor)]

        cellConstraints.append(contentsOf: titleLabelConstraints)
        cellConstraints.append(contentsOf: dateLabelConstraints)
        cellConstraints.append(contentsOf: bodyLabelConstraints)

        NSLayoutConstraint.activate(cellConstraints)
    }
}
