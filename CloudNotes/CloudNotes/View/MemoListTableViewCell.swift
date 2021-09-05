//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/08/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier = "MemoListCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addContentView()
        ConfigureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func addContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(shortDiscriptionLabel)
    }
    
    private func ConfigureAutoLayout() {
        let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin / 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: margin),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin / 2),
           
            
            shortDiscriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            shortDiscriptionLabel.leadingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor, constant: margin * 2),
            shortDiscriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: margin),
            shortDiscriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin / 2)
        ])
    }
    
}

