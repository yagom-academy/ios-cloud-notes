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
        updateFontStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(on memo: MemoEntity) {
        memoTitleLabel.text = memo.title
        previewBodyLabel.text = memo.body
        lastModifiedLabel.text = memo.formatedLastModified
    }
}

extension MemoTableViewCell {
    private func updateFontStyle() {
        let titleFontSize = 20
        let defaultFontSize = 16
        
        memoTitleLabel.font =  UIFont.boldSystemFont(ofSize: CGFloat(titleFontSize))
        lastModifiedLabel.font = UIFont.systemFont(ofSize: CGFloat(defaultFontSize))
        previewBodyLabel.font = UIFont.systemFont(ofSize: CGFloat(defaultFontSize))
        
        previewBodyLabel.textColor = .gray
    }
    
    private func updateLayout() {
        let cellLeadingConstant = 20
        let cellTrailingConstant = 10
        let cellVerticalConstant = 5
        
        updateTitleLayout(leadingConstant: cellLeadingConstant,
                          verticalConstant: cellVerticalConstant,
                          trailingConstant: cellTrailingConstant)
        updateLastModifiedLayout(verticalConstant: cellVerticalConstant)
        updatePreviewBodyLabelLayout(verticalConstant: cellVerticalConstant,
                                     tailingConstant: cellTrailingConstant)
        self.accessoryType = .disclosureIndicator
    }
    
    private func updateTitleLayout(leadingConstant: Int, verticalConstant: Int, trailingConstant: Int) {
        memoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(memoTitleLabel)
        memoTitleLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: CGFloat(leadingConstant)
        ).isActive = true
        
        memoTitleLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: CGFloat(verticalConstant)
        ).isActive = true
        
        memoTitleLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: CGFloat(-trailingConstant)
        ).isActive = true
    }
    
    private func updateLastModifiedLayout(verticalConstant: Int) {
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(lastModifiedLabel)
        lastModifiedLabel.leadingAnchor.constraint(
            equalTo: memoTitleLabel.leadingAnchor
        ).isActive = true
        
        lastModifiedLabel.topAnchor.constraint(
            equalTo: memoTitleLabel.bottomAnchor
        ).isActive = true
        
        lastModifiedLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: CGFloat(-verticalConstant)
        ).isActive = true
    }
    
    private func updatePreviewBodyLabelLayout(verticalConstant: Int, tailingConstant: Int) {
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
            constant: CGFloat(-verticalConstant)
        ).isActive = true
        
        previewBodyLabel.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: CGFloat(-tailingConstant)
        ).isActive = true
    }
}
