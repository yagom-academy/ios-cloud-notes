//
//  CustomCell.swift
//  CloudNotes
//
//  Created by yun on 2021/09/03.
//

import UIKit

class CustomCell: UITableViewCell {
    // MARK: - Properties
    static let cellIdentifier = "cellIdentifier"
    let title = UILabel()
    let lastModification = UILabel()
    let shortDescription = UILabel()
    
    // MARK: Methods
    
    func bind(with model: CustomViewModel<CustomCell>) {
        self.title.text = model.customType.title.text
        self.lastModification.text = model.customType.lastModification.text
        self.shortDescription.text = model.customType.shortDescription.text
    }
    
    private func addViews() {
        contentView.addSubview(title)
        contentView.addSubview(lastModification)
        contentView.addSubview(shortDescription)
    }
    
    private func setConstraints() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.lastModification.translatesAutoresizingMaskIntoConstraints = false
        self.shortDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            lastModification.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            lastModification.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            lastModification.widthAnchor.constraint(equalToConstant: 100),
            
            shortDescription.leadingAnchor.constraint(equalTo: lastModification.trailingAnchor, constant: 20),
            shortDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            shortDescription.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            shortDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setAccessoryView() {
        self.accessoryType = .disclosureIndicator
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.cellIdentifier)
        addViews()
        setConstraints()
        setAccessoryView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
