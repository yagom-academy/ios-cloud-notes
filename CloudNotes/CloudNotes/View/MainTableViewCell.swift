//
//  MainTableViewCell.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/03.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var subTitleLabel: UILabel!
    var dateLabel: UILabel!
    var detailButton: UIButton!
    
    var dateAndSubStackView: UIStackView!
    var titleDateSubStackView: UIStackView!
    var labelsStackView: UIStackView!
    var wholeStackView: UIStackView!
    
    var memoList: MemoDecodeModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        subTitleLabel = UILabel()
        dateLabel = UILabel()
        detailButton = UIButton()
        contentView.addSubview(titleLabel)
        makeHorizontalStackVeiw()
        setupTitleLabelLayout()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableViewCell {
    private func setupTitleLabelLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: dateAndSubStackView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        titleLabel.textAlignment = .left
        
    }
    
    private func makeVerticalStackVeiw() {
        
        titleDateSubStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.dateAndSubStackView])
        titleDateSubStackView.translatesAutoresizingMaskIntoConstraints = false
        titleDateSubStackView.axis = .vertical
        titleDateSubStackView.distribution = .equalSpacing
        titleDateSubStackView.alignment = .leading
        //titleDateSubStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        titleDateSubStackView.setAnchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor)
    }
    
    private func makeHorizontalStackVeiw() {
        
        dateAndSubStackView = UIStackView(arrangedSubviews: [self.dateLabel, self.subTitleLabel])
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(dateAndSubStackView)
        dateAndSubStackView.translatesAutoresizingMaskIntoConstraints = false
        dateAndSubStackView.axis = .horizontal
        dateAndSubStackView.distribution = .equalCentering
        dateAndSubStackView.spacing = 40
        dateAndSubStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateAndSubStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        dateAndSubStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        dateAndSubStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
//    private func makeButtonLayout() {
//        self.detailButton = UIButton()
//        detailButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        detailButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        contentView.addSubview(detailButton)
//        detailButton.setAnchor(top: contentView.topAnchor,
//                               bottom: contentView.bottomAnchor,
//                               leading: safeAreaLayoutGuide.leadingAnchor,
//                               trailing: contentView.trailingAnchor)
//    }
    
}
