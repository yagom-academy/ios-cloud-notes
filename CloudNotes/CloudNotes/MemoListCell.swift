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
    let title = UILabel()
    let date = UILabel()
    let preview = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "MemoListCell")
        
        setCellStackViewAttribute()
        setLabelAttribute()
        setLabelConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: "MemoListCell")
        
        setCellStackViewAttribute()
        setLabelAttribute()
        setLabelConstraints()
    }
    
    func setCellStackViewAttribute() {
        cellStackView.axis = .vertical
        cellStackView.alignment = .leading
        cellStackView.distribution = .fill
        
        bottomStackView.axis = .horizontal
        bottomStackView.alignment = .center
        bottomStackView.distribution = .fill
    }
    
    func setLabelAttribute() {
        title.font = UIFont.systemFont(ofSize: 18)
        date.font = UIFont.systemFont(ofSize: 14)
        preview.font = UIFont.systemFont(ofSize: 14)
        preview.textColor = .systemGray
    }
    
    func setLabelConstraints() {
        self.addSubview(cellStackView)
        cellStackView.addArrangedSubview(title)
        cellStackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(date)
        bottomStackView.addArrangedSubview(preview)
        
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        
        let cellStackViewConstraints = ([
            cellStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            cellStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            cellStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cellStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
        
        date.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3).isActive = true
        
        NSLayoutConstraint.activate(cellStackViewConstraints)
    }

}
