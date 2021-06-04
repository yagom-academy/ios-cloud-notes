//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation
import UIKit

class MemoListCell: UITableViewCell {
    
    static let identifier = "memoListCell"
    let memoTitle = UILabel()
    let memoDateCreate = UILabel()
    let memoPreview = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        memoTitle.translatesAutoresizingMaskIntoConstraints = false
        memoDateCreate.translatesAutoresizingMaskIntoConstraints = false
        memoPreview.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(memoTitle)
        self.addSubview(memoDateCreate)
        self.addSubview(memoPreview)
        
        memoTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        memoTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        memoTitle.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
         
        memoDateCreate.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        memoDateCreate.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
       
        memoPreview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        memoPreview.widthAnchor.constraint(equalTo: memoDateCreate.widthAnchor, multiplier: 1).isActive = true
        memoPreview.heightAnchor.constraint(equalTo: memoTitle.heightAnchor, multiplier: 1).isActive = true
        
        memoPreview.topAnchor.constraint(equalTo: memoTitle.bottomAnchor, constant: 1).isActive = true
        memoPreview.leadingAnchor.constraint(equalTo: memoDateCreate.trailingAnchor, constant: 1).isActive = true
        
        memoPreview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        memoPreview.heightAnchor.constraint(equalTo: memoDateCreate.heightAnchor, multiplier: 1).isActive = true
        self.accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
