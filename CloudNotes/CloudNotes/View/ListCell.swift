//
//  ListCell.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/02.
//

import UIKit

// custom cell
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
    label.text = "Summary"
    return label
  }()
  
  private let button: UIButton = {
    let button = UIButton()
    let image = UIImage(systemName: "greaterthan")
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  private let stackView1: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillProportionally
    stackView.spacing = 0
    
    return stackView
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
    //    contentView.backgroundColor = .orange
    
    stackView3.addArrangedSubview(dateLabel)
    stackView3.addArrangedSubview(summaryLabel)
    
    stackView2.addArrangedSubview(titleLabel)
    stackView2.addArrangedSubview(stackView3)
    
    stackView1.addArrangedSubview(stackView2)
    stackView1.addArrangedSubview(button)
    
    contentView.addSubview(stackView1)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    stackView3.frame = contentView.bounds
    stackView2.frame = contentView.bounds
    stackView1.frame =
      CGRect(x: 5, y: -5,
             width: contentView.frame.size.width-10,
             height: contentView.frame.size.height)
  }
  
  func update(info: MemoInfo) {
    titleLabel.text = info.title
    dateLabel.text = "\(info.date)"
  }
}
