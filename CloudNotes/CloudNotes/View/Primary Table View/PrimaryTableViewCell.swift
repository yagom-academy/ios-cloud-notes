//
//  PrimaryTableViewCell.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "primary"
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
                
        self.addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: textLabel?.bottomAnchor ?? self.contentView.topAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                 constant: self.contentView.bounds.width / 5 * 2),
            summaryLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PrimaryTableViewCell {
    
    func configure(title: String?, detail: String?, date: Double?) {
        self.textLabel?.text = title
        self.detailTextLabel?.text = "\(date)\(date)\(date)\(date). \(date)\(date). \(date)\(date)"
        summaryLabel.text = detail
    }
    
}
