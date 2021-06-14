//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/03.
//

import UIKit

class MemoListCell: UITableViewCell {
    
    let cellStackView = UIStackView()
    let bottomStackView = UIStackView()
    let cellTitle = UILabel()
    let cellDate = UILabel()
    let cellBody = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "MemoListCell")
        
        self.accessoryType = .disclosureIndicator
        self.addSubview(cellStackView)
        setCellStackViewAttribute()
        setLabelAttribute()
        setLabelConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: "MemoListCell")
        
        self.accessoryType = .disclosureIndicator
        self.addSubview(cellStackView)
        setCellStackViewAttribute()
        setLabelAttribute()
        setLabelConstraints()
    }
    
    private func convertDateFormat(date: Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. MM. dd"
        
        let convertDate = Date(timeIntervalSince1970: date)
        let result = dateFormatter.string(from: convertDate)
        
        return result
    }
    
    func bindCellContent(item: MemoData) {
        let date = convertDateFormat(date: item.lastModified)
        
        self.cellTitle.text = item.title
        self.cellDate.text = date
        self.cellBody.text = item.body
    }
    
    private func setCellStackViewAttribute() {
        cellStackView.axis = .vertical
        cellStackView.alignment = .leading
        cellStackView.distribution = .fill
        
        bottomStackView.axis = .horizontal
        bottomStackView.alignment = .center
        bottomStackView.distribution = .fill
    }
    
    private func setLabelAttribute() {
        cellTitle.font = UIFont.systemFont(ofSize: 18)
        cellDate.font = UIFont.systemFont(ofSize: 14)
        cellBody.font = UIFont.systemFont(ofSize: 14)
        cellBody.textColor = .systemGray
    }
    
    private func setLabelConstraints() {
        cellStackView.addArrangedSubview(cellTitle)
        cellStackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(cellDate)
        bottomStackView.addArrangedSubview(cellBody)
        
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellDate.translatesAutoresizingMaskIntoConstraints = false
        
        let cellStackViewConstraints = ([
            cellStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            cellStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            cellStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cellStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
        
        cellDate.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        
        NSLayoutConstraint.activate(cellStackViewConstraints)
    }

}
