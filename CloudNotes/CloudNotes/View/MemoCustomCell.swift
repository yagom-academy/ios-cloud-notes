//
//  MemoCustomCell.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/06.
//

import UIKit

class MemoCustomCell: UITableViewCell {
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .black
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    
    let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.textColor = .systemGray
        bodyLabel.adjustsFontForContentSizeCategory = true
        return bodyLabel
    }()
    
    let lastModifiedLabel: UILabel = {
        let lastModifiedLabel = UILabel()
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        lastModifiedLabel.textColor = .black
        lastModifiedLabel.adjustsFontForContentSizeCategory = true
        return lastModifiedLabel
    }()
    
    lazy var horizontalStackView: UIStackView = {
        var horizontalStackView = UIStackView(arrangedSubviews: [lastModifiedLabel, bodyLabel])
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 50
        horizontalStackView.axis = .horizontal
        contentView.addSubview(horizontalStackView)
        return horizontalStackView
    }()
    
    lazy var veticalStackView: UIStackView = {
        var veticalStackView = UIStackView(arrangedSubviews: [titleLabel, horizontalStackView])
        veticalStackView.alignment = .fill
        veticalStackView.distribution = .fill
        veticalStackView.translatesAutoresizingMaskIntoConstraints = false
        veticalStackView.spacing = 1
        veticalStackView.axis = .vertical
        contentView.addSubview(veticalStackView)
        return veticalStackView
    }()
    
    static let cellIdentifier = "CustomCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MemoCustomCell.cellIdentifier)
        self.accessoryType = .disclosureIndicator
        setHorizontalCompressionResistance()
        setLayoutForStackView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setHorizontalCompressionResistance() {
        lastModifiedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func setLayoutForStackView() {
        NSLayoutConstraint.activate([
            veticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            veticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            veticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            veticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    func configureContent(from memo: MemoEntity, with date: String?) {
        titleLabel.text = memo.title
        bodyLabel.text = memo.body
        lastModifiedLabel.text = date
    }
}
