//
//  MemoCell.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import UIKit

final class MemoCell: UITableViewCell {

    // MARK: UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private let lastModifiedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let oneLineBodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray
        return label
    }()

    private let footStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        configureContentView()
        configureContentStackView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Prepare

    override func prepareForReuse() {
        titleLabel.text = nil
        lastModifiedDateLabel.text = nil
        oneLineBodyLabel.text = nil
    }

    // MARK: Configure

    func configure(memo: Memo) {
        self.titleLabel.text = (memo.title == "" ? "새로운 메모" : memo.title)
        self.lastModifiedDateLabel.text = DateFormatter().currentLocaleString(from: memo.lastModified)
        self.oneLineBodyLabel.text = (memo.body == "" ? "추가 텍스트 없음" : memo.body)
    }

    private func configureContentView() {
        contentView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: separatorInset.left),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -separatorInset.left),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }

    private func configureContentStackView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(footStackView)
        footStackView.addArrangedSubview(lastModifiedDateLabel)
        footStackView.addArrangedSubview(oneLineBodyLabel)
    }

}

// MARK: - DateFormatter

extension DateFormatter {

    fileprivate func currentLocaleString(from timeInterval: TimeInterval) -> String {
        self.dateStyle = .short
        self.timeStyle = .none
        self.locale = Locale.current
        return string(from: Date(timeIntervalSince1970: timeInterval))
    }

}
