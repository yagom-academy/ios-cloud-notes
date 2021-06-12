//
//  ListCell.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit

final class ListCell: UITableViewCell {
  static let identifier = "TableViewCell"
  private let dateConvertor = DateConvertor()
  
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
  
  private let stackOfTitleAndSubtitle: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 10
    stackView.isBaselineRelativeArrangement = true
    
    return stackView
  }()
  
  private let stackOfDateAndSummary: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 0
    
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    stackOfDateAndSummary.addArrangedSubview(dateLabel)
    stackOfDateAndSummary.addArrangedSubview(summaryLabel)
    
    stackOfTitleAndSubtitle.addArrangedSubview(titleLabel)
    stackOfTitleAndSubtitle.addArrangedSubview(stackOfDateAndSummary)
    
    contentView.addSubview(stackOfTitleAndSubtitle)
    
    self.accessoryType = .disclosureIndicator
  }
  
  required init?(coder decoder: NSCoder) {
      super.init(coder: decoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    stackOfDateAndSummary.frame = contentView.bounds
    stackOfTitleAndSubtitle.frame = contentView.bounds
  }
  
  func update(info: MemoInfo) {
    titleLabel.text = info.title
    dateLabel.text = dateConvertor.numberToString(number: info.lastModified)
    summaryLabel.text = info.body?.components(separatedBy: ".").first
  }
}
