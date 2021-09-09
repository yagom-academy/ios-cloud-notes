//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var titleLabel: UILabel!
    private var dateLabel: UILabel!
    private var previewLabel: UILabel!
    
    var cellViewModel: MemoCellViewModel? {
        didSet {
            titleLabel.text = cellViewModel?.title
            dateLabel.text = cellViewModel?.lastModified.description
            previewLabel.text = cellViewModel?.body
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
        contentView.addSubview(titleWithDetailStackView)
        configureStackViewAnchor()
        
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    private func configureLabelsView() {
        titleLabel = UILabel()
        dateLabel = UILabel()
        previewLabel = UILabel()
        
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
    
    // MARK: - Auto Layout
    private func configureStackViewAnchor() {
        titleWithDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleWithDetailStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
            .isActive = true
        titleWithDetailStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
            .isActive = true
        titleWithDetailStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
            .isActive = true
        titleWithDetailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            .isActive = true
    }
}
