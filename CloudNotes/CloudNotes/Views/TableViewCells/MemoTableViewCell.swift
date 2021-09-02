//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/02.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    static let identifier = "MemoListCell"
    
    private let memoTitleLabel = UILabel()
    private let lastModifiedLabel = UILabel()
    private let previewBodyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        updateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        updateTitleLayout()
        updateLastModifiedLayout()
        updatePreviewBodyLabelLayout()
        self.accessoryType = .disclosureIndicator
    }
    
    func configure(on memo: Memo) {
        memoTitleLabel.text = memo.title
        memoTitleLabel.backgroundColor = .orange
        lastModifiedLabel.text = memo.lastModified.description
        previewBodyLabel.text = memo.previewBody
    }
}

extension MemoTableViewCell {
    private func updateTitleLayout() {
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(memoTitleLabel)
        memoTitleLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 0
        ).isActive = true
        
        memoTitleLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: 0
        ).isActive = true
        
        memoTitleLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: 0
        ).isActive = true
    }
    
    private func updateLastModifiedLayout() {
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(lastModifiedLabel)
        lastModifiedLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 0
        ).isActive = true
        
        lastModifiedLabel.topAnchor.constraint(
            equalTo: memoTitleLabel.bottomAnchor,
            constant: 0
        ).isActive = true
        
        lastModifiedLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: 0
        ).isActive = true
    }
    
    private func updatePreviewBodyLabelLayout() {
        previewBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(previewBodyLabel)
        previewBodyLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: 150
        ).isActive = true
        
        previewBodyLabel.topAnchor.constraint(
            equalTo: memoTitleLabel.bottomAnchor,
            constant: 0
        ).isActive = true
        
        previewBodyLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: 0
        ).isActive = true
        
        previewBodyLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: 0
        ).isActive = true
    }
}
