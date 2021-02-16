//
//  ListCell.swift
//  CloudNotes
//
//  Created by 이학주 on 2021/02/16.
//

import UIKit

class ListCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "testTitle"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = "testData"
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()
    private let contentsLabel: UILabel = {
        let contentsLabel = UILabel()
        contentsLabel.text = "testContents"
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        return contentsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentsLabel)
    }
}
