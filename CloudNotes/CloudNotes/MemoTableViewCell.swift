//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var previewLabel: UILabel!

    lazy var dateAndPreviewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        return stackView
    }()

    lazy var titleWithDetailStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [titleLabel, dateAndPreviewStackView])

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually

        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()

        contentView.addSubview(titleWithDetailStackView)

        titleWithDetailStackView.translatesAutoresizingMaskIntoConstraints = false

        titleWithDetailStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
            .isActive = true
        titleWithDetailStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16)
            .isActive = true
        titleWithDetailStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
            .isActive = true
        titleWithDetailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
            .isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUp() {
        titleLabel = UILabel()
        dateLabel = UILabel()
        previewLabel = UILabel()

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true

        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true

        previewLabel.font = UIFont.preferredFont(forTextStyle: .body)
        previewLabel.adjustsFontForContentSizeCategory = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
