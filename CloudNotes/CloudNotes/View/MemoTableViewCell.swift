//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by 예거 on 2022/02/08.
//

import UIKit

private enum PlaceholderText {
    static let title = "새로운 메모"
    static let body = "추가 텍스트 없음"
}

class MemoTableViewCell: UITableViewCell {    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellLayout()
        configureCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCellContent(from memo: Memo) {
        let trimmedBodyText = memo.body?.trimmingCharacters(in: CharacterSet(charactersIn: .lineBreak))
        
        titleLabel.text = memo.title?.isEmpty == true ? PlaceholderText.title : memo.title
        dateLabel.text = memo.lastModified.dateString
        previewLabel.text = trimmedBodyText?.isEmpty == true ? PlaceholderText.body : trimmedBodyText
    }
    
    private func configureCellLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(previewLabel)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            previewLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            previewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            previewLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }
    
    private func configureCellAppearance() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBlue
        self.selectedBackgroundView = backgroundView
        
        self.accessoryType = .disclosureIndicator
    }
}
