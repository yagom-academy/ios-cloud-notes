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
    var horizontalStackView: UIStackView!
    var veticalStackView: UIStackView!
    
    private let cellIdentifier = "CustomCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: cellIdentifier)
        self.accessoryType = .disclosureIndicator
        makeTitleLabel()
        makeBodyLabel()
        makeLastModifiedLabel()
        makeHorizontalStackView()
        makeVerticalStackView()
        setLayoutForStackView()
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
    
    private func setHorizontalCompressionResistance() {
        lastModifiedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func makeHorizontalStackView() {
        setHorizontalCompressionResistance()
        
        horizontalStackView = UIStackView(arrangedSubviews: [lastModifiedLabel, bodyLabel])
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.spacing = 50
        horizontalStackView.axis = .horizontal
        contentView.addSubview(horizontalStackView)
    }
    
    private func makeVerticalStackView() {
        veticalStackView = UIStackView(arrangedSubviews: [titleLabel, horizontalStackView])
        veticalStackView.alignment = .fill
        veticalStackView.distribution = .fill
        veticalStackView.translatesAutoresizingMaskIntoConstraints = false
        veticalStackView.spacing = 1
        veticalStackView.axis = .vertical
        contentView.addSubview(veticalStackView)
    }
    
    private func setLayoutForStackView() {
        NSLayoutConstraint.activate([
                                     veticalStackView.leadingAnchor.constraint(equalTo:contentView.leadingAnchor),
                                     veticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                     veticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                                     veticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
