//
//  ItemListViewCell.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class ItemListViewCell: UITableViewCell {
    static let identifier = "ItemListViewCell"
    
    lazy var titleLabel = createdTitleLabel()
    lazy var dateLabel = createdDateLabel()
    lazy var descriptionLabel = createdDescriptionLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension ItemListViewCell {
    
    private var baseLabel: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        contentView.addSubview(label)
        
        return label
    }
    
    func createdTitleLabel() -> UILabel {
        let label = baseLabel
        
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        
        return label
    }
    
    
    func createdDateLabel() -> UILabel {
        let label = baseLabel
        
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 0.5).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        
        return label
    }
    
    func createdDescriptionLabel() -> UILabel {
        let label = baseLabel
        
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 0.5).isActive = true
        label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        
        return label
    }
}
