//
//  MemoCustomCell.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/06.
//

import UIKit

class MemoCustomCell: UITableViewCell {
    var titleLabel: UILabel!
    var bodyLabel: UILabel!
    var lastModifiedLabel: UILabel!
    
    private let cellIdentifier = "CustomCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: cellIdentifier)
        makeTitleLabel()
        makeBodyLabel()
        makeLastModifiedLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func makeTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .black
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func makeBodyLabel() {
        bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.textColor = .systemGray
        bodyLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func makeLastModifiedLabel() {
        lastModifiedLabel = UILabel()
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        lastModifiedLabel.textColor = .black
        lastModifiedLabel.adjustsFontForContentSizeCategory = true
    }
}
