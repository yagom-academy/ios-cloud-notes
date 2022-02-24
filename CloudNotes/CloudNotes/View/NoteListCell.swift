//
//  NoteListCell.swift
//  CloudNotes
//
//  Created by 황제하 on 2022/02/08.
//

import UIKit

final class NoteListCell: UITableViewCell {
    
    // MARK: - properties
    
    static let identifier = "NoteListCell"
    
    private let cellStackView = UIStackView()
    private let dateAndContentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()
    
    // MARK: - init Method
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
          style: style,
          reuseIdentifier: reuseIdentifier
        )
        setupAddSubviews()
        setupCellStackView()
        setupCellStackViewConstraint()
        setupDateAndContentStackView()
        setupTitleLabel()
        setupDateLabel()
        setupContentLabel()
        setupAccessory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - internal Methods
    
    func configure(with note: Note) {
        titleLabel.text = note.title == "" ? "New Note".localized : note.title
        contentLabel.text = note.content == "" ? "No addtional text".localized : note.content
        dateLabel.text = note.localizedDateString
    }
    
    // MARK: - private Methods
    
    private func setupAddSubviews() {
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(dateAndContentStackView)
        dateAndContentStackView.addArrangedSubview(dateLabel)
        dateAndContentStackView.addArrangedSubview(contentLabel)
    }
    
    private func setupCellStackView() {
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.spacing = 8
        let inset: CGFloat = 10
        cellStackView.layoutMargins = UIEdgeInsets(
          top: inset,
          left: inset,
          bottom: inset,
          right: inset
        )
        cellStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupCellStackViewConstraint() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupDateAndContentStackView() {
        dateAndContentStackView.axis = .horizontal
        dateAndContentStackView.alignment = .center
        dateAndContentStackView.spacing = 10
    }
    
    private func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setupDateLabel() {
        dateLabel.textAlignment = .left
        dateLabel.font = .preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.setContentHuggingPriority(
          .required,
          for: .horizontal
        )
        dateLabel.setContentCompressionResistancePriority(
          .required,
          for: .horizontal
        )
    }
    
    private func setupContentLabel() {
        contentLabel.textAlignment = .left
        contentLabel.font = .preferredFont(forTextStyle: .caption1)
        contentLabel.adjustsFontForContentSizeCategory = true
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.textColor = .systemGray
    }
    
    private func setupAccessory() {
        accessoryType = .disclosureIndicator
    }
}
