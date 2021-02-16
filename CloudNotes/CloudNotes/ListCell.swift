//
//  ListCell.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/16.
//

import UIKit

class ListCell: UITableViewCell {
    
    static let identifier = "ListCell"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "testTitle"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        return titleLabel
    }()
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "testData"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    private let contentsLabel: UILabel = {
        let contentsLabel = UILabel()
        contentsLabel.text = "testContents"
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentsLabel.textColor = .darkGray
        return contentsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentsLabel)
    }
    
    private func setAutoLayout() {
        let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
        
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            
            contentsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            contentsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: margin * 5)
        ])
    }
}
