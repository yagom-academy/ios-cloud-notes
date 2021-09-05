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
        makeButtonLayout()
        contentView.addSubview(titleLabel)
        makeHorizontalStackVeiw()
        
        setupLayout()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        //makeVerticalStackVeiw()
    }
    
    //    override func updateConfiguration(using state: UICellConfigurationState) {
    //        super.updateConfiguration(using: state)
    //
    //        var configuration = defaultContentConfiguration()
    //
    //
    //        configuration.secondaryText = "\(memoList?.lastModified)"
    //        contentConfiguration = configuration
    //    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTableViewCell {
    private func setupLayout() {
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
        titleDateSubStackView.setAnchor(top: contentView.topAnchor, bottom: dateAndSubStackView.bottomAnchor, leading: contentView.leadingAnchor, trailing: nil)
    }
    
    private func makeHorizontalStackVeiw() {
        dateAndSubStackView = UIStackView(arrangedSubviews: [self.dateLabel, self.subTitleLabel])
        subTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(dateAndSubStackView)
        dateAndSubStackView.translatesAutoresizingMaskIntoConstraints = false
        dateAndSubStackView.axis = .horizontal
        dateAndSubStackView.distribution = .equalCentering
        //dateAndSubStackView.alignment = .center
        
        dateAndSubStackView.spacing = 40
        dateAndSubStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateAndSubStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dateAndSubStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        dateAndSubStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        
        
    }
    
    
    private func makeButtonLayout() {
        self.detailButton = UIButton()
        contentView.addSubview(detailButton)
        detailButton.setAnchor(top: contentView.topAnchor,
                               bottom: contentView.bottomAnchor,
                               leading: nil,
                               trailing: contentView.trailingAnchor)
    }
    
}
