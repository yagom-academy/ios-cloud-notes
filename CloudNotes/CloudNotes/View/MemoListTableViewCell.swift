//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/08/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier = "memoListTableViewCell"

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.textColor = .black
        bodyLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        return bodyLabel
    }()

    private let lastModifiedLabel: UILabel = {
        let lastModifiedLabel = UILabel()
        lastModifiedLabel.font = UIFont.preferredFont(forTextStyle: .body)
        lastModifiedLabel.textColor = .black
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        return lastModifiedLabel
    }()

}

extension MemoListTableViewCell {
    func configure(with: Memo) {
        
    }
}
