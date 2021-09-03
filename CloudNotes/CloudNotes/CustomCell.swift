//
//  CustomCell.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

class CustomCell: UITableViewCell {
    static let cellIdentifier = "cellIdentifier"
    let title = UILabel()
    let lastModification = UILabel()
    let shortDescription = UILabel()
    
    private func setConstraints() {
        contentView.addSubview(title)
        contentView.addSubview(lastModification)
        contentView.addSubview(shortDescription)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        lastModification.translatesAutoresizingMaskIntoConstraints = false
        shortDescription.translatesAutoresizingMaskIntoConstraints = false
        
        title.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        lastModification.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0).isActive = true
        lastModification.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        lastModification.widthAnchor.constraint(equalToConstant: 100).isActive = true

        shortDescription.leadingAnchor.constraint(equalTo: lastModification.trailingAnchor, constant: 20).isActive = true
        shortDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        shortDescription.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0).isActive = true
        shortDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
}
