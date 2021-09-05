//
//  MainTableViewCell.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/03.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    private var titleLabel: UILabel!
    private var bodyLabel: UILabel!
    private var dateLabel: UILabel!
    private var dateAndBodyStackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabelLayout()
        makeHorizontalStackVeiw()
        setLabelStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableViewCell {
    func configure(_ dataHolder: CellContentDataHolder) {
        titleLabel.text = dataHolder.titleLabelText
        bodyLabel.text = dataHolder.bodyLabelText
        dateLabel.text = dataHolder.dateLabelText
        self.accessoryType = dataHolder.accessoryType
    }
    
    private func setupTitleLabelLayout() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        
        //titleLabel.setPosition(top: nil, bottom: dateAndBodyStackView.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, leadingConstant: 10, trailing: safeAreaLayoutGuide.trailingAnchor)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.textAlignment = .left
        
    }
    
    private func makeHorizontalStackVeiw() {
        dateLabel = UILabel()
        bodyLabel = UILabel()
        dateAndBodyStackView = UIStackView(arrangedSubviews: [self.dateLabel, self.bodyLabel])
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(dateAndBodyStackView)
        dateAndBodyStackView.translatesAutoresizingMaskIntoConstraints = false
        dateAndBodyStackView.axis = .horizontal
        dateAndBodyStackView.distribution = .equalCentering
        dateAndBodyStackView.spacing = 40
        
        //        dateAndBodyStackView.setPosition(top: titleLabel.bottomAnchor,
        //                                         bottom: contentView.bottomAnchor,
        //                                         leading: contentView.leadingAnchor,
        //                                         trailing: contentView.trailingAnchor,
        //                                         trailingConstant: -20)
        
        dateAndBodyStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateAndBodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dateAndBodyStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        dateAndBodyStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    func setLabelStyle() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        bodyLabel.textColor = .gray
    }
}

class CellContentDataHolder {
    var titleLabelText: String?
    var dateLabelText: String?
    var bodyLabelText: String?
    var accessoryType: UITableViewCell.AccessoryType
    
    init(title: String?, date: String?, body: String?, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator) {
        self.titleLabelText = title
        self.dateLabelText = date
        self.bodyLabelText = body
        self.accessoryType = accessoryType
    }
}
