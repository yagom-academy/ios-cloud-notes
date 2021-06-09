//
//  MemoCell.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/02.
//

import UIKit

final class MemoCell: UITableViewCell {

    // MARK: Property

    static let reuseIdentifier: String = "memoCell"

    // MARK: UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.titleLabelFont
        return label
    }()

    private let lastModifiedDateLabel: UILabel = {
        let label = UILabel()
        label.font = Style.lastModifiedDateLabelFont
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let oneLineBodyLabel: UILabel = {
        let label = UILabel()
        label.font = Style.oneLineBodyLabelFont
        label.textColor = Style.oneLineBodyLabelTextColor
        return label
    }()

    private let footStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = Style.footStackViewSpacing
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
        self.titleLabel.text = (memo.isTitleEmpty ? Style.titleLabelPlaceHolder : memo.title)
        self.lastModifiedDateLabel.text = DateFormatter().currentLocaleString(from: memo.lastModified)
        self.oneLineBodyLabel.text = (memo.isBodyEmpty ? Style.oneLineBodyLabelPlaceHolder : memo.body)
    }

    private func configureContentView() {
        contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Style.contentStackViewVerticalInset),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: separatorInset.left),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -separatorInset.left),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Style.contentStackViewVerticalInset)
        ])
    }

    private func configureContentStackView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(footStackView)
        footStackView.addArrangedSubview(lastModifiedDateLabel)
        footStackView.addArrangedSubview(oneLineBodyLabel)
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        var background = UIBackgroundConfiguration.listPlainCell()

        if state.isHighlighted || state.isSelected {
            background.backgroundColor = Style.highlightedBackgroundColor
        } else {
            background.backgroundColor = Style.commonBackgroundColor
        }

        backgroundConfiguration = background
    }

}

// MARK: - Style

extension MemoCell {

    enum Style {
        static let titleLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
        static let titleLabelPlaceHolder: String = "새로운 메모"

        static let lastModifiedDateLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote)

        static let oneLineBodyLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote)
        static let oneLineBodyLabelPlaceHolder: String = "추가 텍스트 없음"
        static let oneLineBodyLabelTextColor: UIColor = .systemGray

        static let footStackViewSpacing: CGFloat = 20

        static let contentStackViewVerticalInset: CGFloat = 5

        static let commonBackgroundColor: UIColor = .systemBackground
        static let highlightedBackgroundColor: UIColor = .systemYellow
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
