//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/01.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier = "MemoListTableViewCell"

    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
    }()
    
    let body: UILabel = {
        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.font = UIFont.systemFont(ofSize: 12)
        
        return body
    }()
    
    
    let lastModified: UILabel = {
        let lastModified = UILabel()
        lastModified.translatesAutoresizingMaskIntoConstraints = false
        lastModified.font = UIFont.systemFont(ofSize: 12)
        
        return lastModified
    }()
    
    
}
