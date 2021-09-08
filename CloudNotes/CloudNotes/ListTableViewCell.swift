//
//  ListTableViewCell.swift
//  CloudNotes
//
//  Created by Ellen on 2021/09/03.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var dateLabel: UILabel!
    
    static let cellIdentifier = "\(ListTableViewCell.self)"
    
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        dateLabel.text = ""
    }
    
    func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
    }
    
    func setUpConstraints() {
        self.accessoryType = .disclosureIndicator
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        
        descriptionLabel.leftAnchor.constraint(equalTo: dateLabel.rightAnchor, constant: 30).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setUpLabels(model: [MemoList], indexPath: IndexPath) {
        let item = model[indexPath.item]
        titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        dateLabel = UILabel()
        dateLabel.text = String(item.lastModified)
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = item.body
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .lightGray
    }
}
