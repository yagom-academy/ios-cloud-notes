//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier = "MemoListTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MemoListTableViewCell.identifier)
        self.constraintsSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: MemoListTableViewCell.identifier)
    }
    
    let title: UILabel = {
        let title = UILabel()
        title.text = "title Text"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 24)
        
        return title
    }()
    
    let body: UILabel = {
        let body = UILabel()
        body.text = "body Text"
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = UIFont.systemFont(ofSize: 15)
        body.textColor = .gray
        
        return body
    }()
    
    
    let lastModified: UILabel = {
        let lastModified = UILabel()
        lastModified.text = "lastModified Text"
        lastModified.translatesAutoresizingMaskIntoConstraints = false
        lastModified.font = UIFont.systemFont(ofSize: 15)
        
        return lastModified
    }()
    
    func constraintsSetup() {
        let margins = self.layoutMarginsGuide
        
        self.addSubview(title)
        self.addSubview(body)
        self.addSubview(lastModified)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: margins.topAnchor),
            title.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3),
            
            lastModified.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            lastModified.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            lastModified.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3),
            
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            body.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            body.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20)
        ])
    }
    
    
}
