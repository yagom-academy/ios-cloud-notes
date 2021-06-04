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
    }
    
    private enum Constraints {
        enum CellStackView {
            static let leading: CGFloat = 20
            static let trailing: CGFloat = -40
            static let top: CGFloat = 10
            static let bottom: CGFloat = -10
        }
    }
    
    // MARK: - Nib Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Configure cell
extension NoteCollectionViewListCell {
    func configure(with note: Note) {
        let cellStackView = createCellStackView()
        addSubview(cellStackView)
        
        titleLabel.text = note.title
        bodyLabel.text = note.body
        lastModifiedDateLabel.text = note.lastModified.formatted
        accessories = [.disclosureIndicator()]
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constraints.CellStackView.leading
            ),
            cellStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Constraints.CellStackView.trailing
            ),
            cellStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constraints.CellStackView.top
            ),
            cellStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Constraints.CellStackView.bottom
            )
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
}
