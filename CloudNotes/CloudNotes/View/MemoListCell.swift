//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import UIKit

class MemoListCell: UITableViewCell {
    
    static let identifier = "memoListCell"
    
    var memoTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)

        return label
    }()
    
    var memoDateCreate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

        return label
    }()
    
    var memoPreview: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(memoTitle)
        self.addSubview(memoDateCreate)
        self.addSubview(memoPreview)
        setCellContentsConstraint()

        self.accessoryType = .disclosureIndicator
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCellContentsConstraint() {
        memoTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        memoTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        memoTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
         
        memoDateCreate.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        memoDateCreate.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
       
        memoPreview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        memoPreview.widthAnchor.constraint(equalTo: memoDateCreate.widthAnchor, multiplier: 1).isActive = true
        memoPreview.heightAnchor.constraint(equalTo: memoTitle.heightAnchor, multiplier: 1).isActive = true
        
        memoPreview.topAnchor.constraint(equalTo: memoTitle.bottomAnchor, constant: 1).isActive = true
        memoPreview.leadingAnchor.constraint(equalTo: memoDateCreate.trailingAnchor, constant: 1).isActive = true
        
        memoPreview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        memoPreview.heightAnchor.constraint(equalTo: memoDateCreate.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setCellData(currentMemoData: Memo) {
        self.memoTitle.text = currentMemoData.title
        self.memoPreview.text = currentMemoData.body
        self.memoDateCreate.text = currentMemoData.lastModifiedDate
        self.accessoryType = .disclosureIndicator
    }
    
}
