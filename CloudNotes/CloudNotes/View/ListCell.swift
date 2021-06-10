//
//  ListCell.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit

class ListCell: UITableViewCell {
  static let identifier = "TableViewCell"
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 17, weight: .bold)
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  private let summaryLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = .systemFont(ofSize: 14, weight: .regular)
    return label
  }()
  
  private let stackView2: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 10
    stackView.isBaselineRelativeArrangement = true
    
    return stackView
  }()
  
  private let stackView3: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    stackView3.addArrangedSubview(dateLabel)
    stackView3.addArrangedSubview(summaryLabel)
    
    stackView2.addArrangedSubview(titleLabel)
    stackView2.addArrangedSubview(stackView3)
    
    contentView.addSubview(stackView2)
    
    self.accessoryType = .disclosureIndicator
  }
  
  required init?(coder decoder: NSCoder) {
      super.init(coder: decoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    stackView3.frame = contentView.bounds
    stackView2.frame = contentView.bounds
  }
  
  func update(info: MemoInfo) {
    titleLabel.text = info.title
    dateLabel.text = DateConvertor().numberToString(number: info.lastModified)
    summaryLabel.text = info.body?.components(separatedBy: ".").first
  }
}
