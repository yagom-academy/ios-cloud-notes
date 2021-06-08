//
//  NoteListCellTableViewCell.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteListCell: UITableViewCell {
    
    private enum Style {
        static let titleLableMargin: UIEdgeInsets = .init(top: 10, left: 15, bottom: 5, right: 5)
        static let dateLableMargin: UIEdgeInsets = .init(top: 5, left: 10, bottom: 15, right: 10)
        static let descriptionLabel: UIEdgeInsets = .init(top: 5, left: 10, bottom: 10, right: 5)
    }
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.lineBreakStrategy = .hangulWordPriority
        title.numberOfLines = 1
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        return title
    }()
    
    private lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.setContentCompressionResistancePriority(.required, for: .horizontal)
        date.font = UIFont.preferredFont(forTextStyle: .headline)
        return date
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = UIColor.systemGray2
        description.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        return description
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func displayData(_ data: Note) {
        titleLabel.text = data.title
        dateLabel.text = data.date
        descriptionLabel.text = data.description
    }
    
    private func selectedCell() {
        let backgroundColorCell = UIView()
        backgroundColorCell.layer.cornerRadius = 15
        backgroundColorCell.backgroundColor = .systemOrange
        self.selectedBackgroundView = backgroundColorCell
    }
    
    private func setConstraint() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
 
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Style.titleLableMargin.left),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Style.titleLableMargin.top),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Style.titleLableMargin.right),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.dateLableMargin.top),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Style.dateLableMargin.bottom),
            dateLabel.trailingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -Style.dateLableMargin.right),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Style.descriptionLabel.right)
        ])
    }
}
