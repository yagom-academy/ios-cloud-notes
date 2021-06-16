//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit

class MemoListCell: UITableViewCell {
    static let identifier = "MemoListTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default , reuseIdentifier: MemoListCell.identifier)
        
        self.accessoryType = .disclosureIndicator
        self.configureCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    private var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 24)
        
        return title
    }()
    
    private var body: UILabel = {
        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = UIFont.systemFont(ofSize: 15)
        body.textColor = .gray
        
        return body
    }()
    
    private var lastModified: UILabel = {
        let lastModified = UILabel()
        lastModified.translatesAutoresizingMaskIntoConstraints = false
        lastModified.font = UIFont.systemFont(ofSize: 15)
        lastModified.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return lastModified
    }()
    
    func configureCell(memoData: MemoData, stringLastModified: String) {
        title.text = memoData.title == StringLiterals.empty.data ? StringLiterals.newMemo.data : memoData.title
        body.text = memoData.body == StringLiterals.empty.data ? StringLiterals.noContent.data : memoData.body
        lastModified.text = stringLastModified
    }
    
    private func configureCellConstraints() {
        let safeArea = contentView.layoutMarginsGuide
        
        contentView.addSubview(title)
        contentView.addSubview(body)
        contentView.addSubview(lastModified)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeArea.topAnchor),
            title.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 3),
            title.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            lastModified.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            lastModified.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            lastModified.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 3),
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            body.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: lastModified.trailingAnchor, constant: 20),
            body.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0)
        ])
    }

}
