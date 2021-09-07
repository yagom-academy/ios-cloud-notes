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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAutoresizingMasks()
        setUpInnerStackView()
        setUpOuterStackView()
        setUpAccessoryView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        summaryLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        innerStackView.distribution = .fill
        innerStackView.alignment = .fill
        innerStackView.spacing = 20
    }

    private func setUpOuterStackView() {
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(outerStackView)
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

//MARK:- Configure Contents
extension MemoItemTableViewCell {
    func configure(with memoItem: Memo) {
        clearAllContents()
        titleLabel.text = memoItem.title
        lastModifiedLabel.text = convertToFormattedDate(from: memoItem.lastModified)
        summaryLabel.text = memoItem.body
    }
    
    private func clearAllContents() {
        titleLabel.text = nil
        lastModifiedLabel.text = nil
        summaryLabel.text = nil
    }
    
    private func convertToFormattedDate(from interval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: interval)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
