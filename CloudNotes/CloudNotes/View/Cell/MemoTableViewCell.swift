//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewCell: UITableViewCell {

    // MARK: - Properties
    private var titleLabel = UILabel()
    private var dateLabel = UILabel()
    private var previewLabel = UILabel()

    var memoCellViewModel: MemoCellViewModel? {
        didSet {
            updateMemoCellViewModel()
        }
    }

    private lazy var dateAndPreviewStackView: UIStackView = {
        let dateAndPreviewStackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])

        dateAndPreviewStackView.translatesAutoresizingMaskIntoConstraints = false
        dateAndPreviewStackView.axis = .horizontal
        dateAndPreviewStackView.spacing = 8
        dateAndPreviewStackView.distribution = .fillEqually

        return dateAndPreviewStackView
    }()

    private lazy var titleWithDetailStackView: UIStackView = {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, dateAndPreviewStackView])

        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .vertical
        titleStackView.spacing = 8
        titleStackView.distribution = .fillEqually

        return titleStackView
    }()

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureLabelsView()
        configureStackViewAnchor()
        configureAccessoryView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    private func updateMemoCellViewModel() {
        titleLabel.text = memoCellViewModel?.title
        dateLabel.text = memoCellViewModel?.lastModified
        previewLabel.text = memoCellViewModel?.body
    }
}

// MARK: - View methods
extension MemoTableViewCell {
    
    func configureAccessoryView() {
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
}

// MARK: - Auto Layout
extension MemoTableViewCell {
    
    func configureLabelsView() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.lineBreakMode = .byTruncatingTail

        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.lineBreakMode = .byTruncatingTail

        previewLabel.font = UIFont.preferredFont(forTextStyle: .body)
        previewLabel.adjustsFontForContentSizeCategory = true
        previewLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configureStackViewAnchor() {
        contentView.addSubview(titleWithDetailStackView)
        
        titleWithDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = titleWithDetailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        let trailingConstraint = titleWithDetailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        let topConstraint = titleWithDetailStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        let bottomConstraint = titleWithDetailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        
        let stackViewConstraints = [leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]
        NSLayoutConstraint.activate(stackViewConstraints)
    }
}
