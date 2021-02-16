//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Yeon on 2021/02/16.
//

import UIKit

final class MemoTableViewCell: UITableViewCell {
    //MARK: Properties
    private var memoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private var memoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemGray
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private var memoModifiedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    //MARK: SetUpMemoTableViewCell
    private func setUpView() {
        contentView.addSubview(memoTitleLabel)
        contentView.addSubview(memoDescriptionLabel)
        contentView.addSubview(memoModifiedDateLabel)
        
        NSLayoutConstraint.activate([
            memoTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            memoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            memoTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            memoModifiedDateLabel.topAnchor.constraint(equalTo: memoTitleLabel.bottomAnchor, constant: 5),
            memoModifiedDateLabel.leadingAnchor.constraint(equalTo: memoTitleLabel.leadingAnchor),
            memoModifiedDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            memoDescriptionLabel.leadingAnchor.constraint(equalTo: memoModifiedDateLabel.trailingAnchor, constant: 30),
            memoDescriptionLabel.topAnchor.constraint(equalTo: memoModifiedDateLabel.topAnchor),
            memoDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            memoDescriptionLabel.bottomAnchor.constraint(equalTo: memoModifiedDateLabel.bottomAnchor)
        ])
    }
    
    func setUpMemoCell(_ memo: Memo) {
        memoTitleLabel.text = memo.title
        memoDescriptionLabel.text = memo.body
        memoModifiedDateLabel.text = memo.modifiedDate.stringFromUTC
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memoTitleLabel.text = nil
        memoDescriptionLabel.text = nil
        memoModifiedDateLabel.text = nil
    }
}
