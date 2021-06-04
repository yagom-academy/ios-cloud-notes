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
    private enum Layout {
        static let spacingInSecondaryTextStackView: CGFloat = 15
        static let spacingInCellStackView: CGFloat = 3
        static let leadingSpaceBetweenCellStackViewAndContentView: CGFloat = 20
        static let trailingSpaceBetweenCellStackViewAndContentView: CGFloat = -40
        static let topSpaceBetweenCellStackViewAndContentView: CGFloat = 10
        static let bottomSpaceBetweenCellStackViewAndContentView: CGFloat = -10
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
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Layout.leadingSpaceBetweenCellStackViewAndContentView),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: Layout.trailingSpaceBetweenCellStackViewAndContentView),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: Layout.topSpaceBetweenCellStackViewAndContentView),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                  constant: Layout.bottomSpaceBetweenCellStackViewAndContentView)
        ])
    }
    
    private func createCellStackView() -> UIStackView {
        let secondaryTextStackView = UIStackView(arrangedSubviews: [lastModifiedDateLabel, bodyLabel])
        secondaryTextStackView.translatesAutoresizingMaskIntoConstraints = false
        secondaryTextStackView.axis = .horizontal
        secondaryTextStackView.alignment = .fill
        secondaryTextStackView.distribution = .fill
        secondaryTextStackView.spacing = Layout.spacingInSecondaryTextStackView
        
        let cellStackView = UIStackView(arrangedSubviews: [titleLabel, secondaryTextStackView])
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .vertical
        cellStackView.alignment = .fill
        cellStackView.distribution = .fill
        cellStackView.spacing = Layout.spacingInCellStackView
        
        return cellStackView
    }
}
