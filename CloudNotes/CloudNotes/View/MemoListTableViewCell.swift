//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/08/31.
//

import UIKit

final class MemoListTableViewCell: UITableViewCell {
    static let identifier = "MemoListCell"
    private let textMaximumCount = 50
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return titleLabel
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
        return dateLabel
    }()
    
    let shortDiscriptionLabel: UILabel = {
        let shortDiscriptionLabel = UILabel()
        shortDiscriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDiscriptionLabel.font = UIFont.boldSystemFont(ofSize: 15)
        shortDiscriptionLabel.textColor = .lightGray
        return shortDiscriptionLabel
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubView()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func editShortText(text: String) -> String {
        guard text.count > textMaximumCount else { return text }
        let endIndex = text.index(text.startIndex, offsetBy: textMaximumCount)
        return text[text.startIndex...endIndex].description
        
    }
    
    private func addSubView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(shortDiscriptionLabel)
    }
    
    func configure(with data: Memo) {
        titleLabel.text = data.title
        shortDiscriptionLabel.text = editShortText(text: data.body)
        dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: data.date))
    }
    
    private func configureAutoLayout() {
        let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin / 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin / 2),
           
            
            shortDiscriptionLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            shortDiscriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: margin),
            shortDiscriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            shortDiscriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin / 2)
        ])
    }
    
}

