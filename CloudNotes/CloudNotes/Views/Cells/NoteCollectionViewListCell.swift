//
//  NoteCollectionViewListCell.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit

final class NoteCollectionViewListCell: UICollectionViewListCell {
    // MARK: - Properties
    static let reuseIdentifier = "NoteCollectionViewListCell"
    
    // MARK: - UI element properties
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    private var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.lineBreakMode = .byTruncatingTail
        bodyLabel.textColor = .gray
        bodyLabel.adjustsFontForContentSizeCategory = true
        return bodyLabel
    }()
    private var lastModifiedDateLabel: UILabel = {
        let lastModifiedDateLabel = UILabel()
        lastModifiedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        lastModifiedDateLabel.adjustsFontForContentSizeCategory = true
        lastModifiedDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        return lastModifiedDateLabel
    }()

    // MARK: - Namespaces
    private enum Layouts {
        static let spacingInSecondaryTextStackView: CGFloat = 15
        static let spacingInCellStackView: CGFloat = 3
        static let contentViewCornerRadius: CGFloat = 10
    }
    
    private enum Constraints {
        enum CellStackView {
            static let leading: CGFloat = 20
            static let trailing: CGFloat = -40
            static let top: CGFloat = 10
            static let bottom: CGFloat = -10
        }
    }
    
    // MARK: - Configure cell
    func configure(with note: Note) {
        let cellStackView = createCellStackView()
        addSubview(cellStackView)
        
        updateContents(note)
        accessories = [.disclosureIndicator()]
        contentView.layer.cornerRadius = Layouts.contentViewCornerRadius
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.CellStackView.leading),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constraints.CellStackView.trailing),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraints.CellStackView.top),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constraints.CellStackView.bottom)
        ])
    }
    
    private func createCellStackView() -> UIStackView {
        let secondaryTextStackView = UIStackView(arrangedSubviews: [lastModifiedDateLabel, bodyLabel])
        secondaryTextStackView.translatesAutoresizingMaskIntoConstraints = false
        secondaryTextStackView.axis = .horizontal
        secondaryTextStackView.alignment = .fill
        secondaryTextStackView.distribution = .fill
        secondaryTextStackView.spacing = Layouts.spacingInSecondaryTextStackView
        
        let cellStackView = UIStackView(arrangedSubviews: [titleLabel, secondaryTextStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.spacing = Layouts.spacingInCellStackView
        
        return cellStackView
    }
    
    func updateContents(_ note: Note) {
        titleLabel.text = note.title == "" ? "새 메모" : note.title
        bodyLabel.text = note.body == "" ? "내용 없음" : note.body
        lastModifiedDateLabel.text = note.lastModified.formatted
    }
    
    // MARK: - Set cell selection effect
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        if state.isSelected {
            contentView.backgroundColor = .systemBlue
        } else {
            contentView.backgroundColor = .systemBackground
        }
    }
}
