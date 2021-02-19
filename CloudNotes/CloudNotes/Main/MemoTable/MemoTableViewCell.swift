//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetUI()
    }
    
    // MAKR: - setup UI
    private func setupUI() {
        self.accessoryType = .disclosureIndicator
        setupTitleLabel()
        setupDateLabel()
        setupBodyLabel()
    }
    
    private func setupTitleLabel() {
        self.contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.accessoryView?.leadingAnchor ?? self.contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupDateLabel() {
        self.contentView.addSubview(dateLabel)
        dateLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setupBodyLabel() {
        self.contentView.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor, constant: 10).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: self.accessoryView?.leadingAnchor ?? self.contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    private func resetUI() {
        titleLabel.text = nil
        dateLabel.text = nil
        bodyLabel.text = nil
    }
    
    // MARK: - display cell method
    func displayUI(with item: Memo) {
        titleLabel.text = item.title
        dateLabel.text = item.dateTimeToString
        bodyLabel.text = item.body
    }
}
