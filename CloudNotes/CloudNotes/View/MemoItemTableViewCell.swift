//
//  MemoItemTableViewCell.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/03.
//

import UIKit

class MemoItemTableViewCell: UITableViewCell {
    private let outerStackView = UIStackView()
    private let innerStackView = UIStackView()
    private let titleLabel = UILabel()
    private let lastModifiedLabel = UILabel()
    private let summaryLabel = UILabel()
    static let identifier = "MemoItemTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAutoresizingMasks()
        setUpInnerStackView()
        setUpOuterStackView()
        setUpAccessoryView()
    }
}

//MARK:- Set View Components
extension MemoItemTableViewCell {
    private func setAutoresizingMasks() {
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpInnerStackView() {
        innerStackView.axis = .horizontal
        innerStackView.addArrangedSubview(lastModifiedLabel)
        innerStackView.addArrangedSubview(summaryLabel)
        innerStackView.distribution = .fill
        innerStackView.alignment = .fill
        innerStackView.spacing = 20
    }

    private func setUpOuterStackView() {
        let marginGuide = contentView.layoutMarginsGuide
        outerStackView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        outerStackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        outerStackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        outerStackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        outerStackView.axis = .vertical
        outerStackView.addArrangedSubview(titleLabel)
        outerStackView.addArrangedSubview(innerStackView)
        outerStackView.distribution = .fill
        outerStackView.alignment = .fill
        outerStackView.spacing = 4
    }
    
    private func setUpAccessoryView() {
        accessoryType = AccessoryType.disclosureIndicator
    }
}
