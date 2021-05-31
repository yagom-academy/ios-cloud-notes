//
//  MemoListTableViewCell.swift
//  CloudNotes
//
//  Created by 최정민 on 2021/05/31.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    
    static let identifier = "MemoListTableViewCell"
    var title = UILabel()
    var writedDate = UILabel()
    var preview = UILabel()
      
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpTableViewCell() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        self.contentView.addSubview(title)
        self.contentView.addSubview(writedDate)
        self.contentView.addSubview(preview)
        setUpTitleLabel(safeArea: safeArea)
        setUpWritedDateLabel(safeArea: safeArea)
        setUpPreviewLabel(safeArea: safeArea)
    }
    
    func setUpTitleLabel(safeArea: UILayoutGuide) {
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 10),
            title.bottomAnchor.constraint(equalTo: writedDate.topAnchor, constant: 5),
        ])
    }
    
    func setUpWritedDateLabel(safeArea: UILayoutGuide) {
        writedDate.textColor = .black
        writedDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            writedDate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            writedDate.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            writedDate.trailingAnchor.constraint(equalTo: preview.leadingAnchor, constant: 50),
            writedDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
        ])
    }
    
    func setUpPreviewLabel(safeArea: UILayoutGuide) {
        preview.textColor = .systemGray4
        preview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            preview.leadingAnchor.constraint(equalTo: writedDate.trailingAnchor, constant: 50),
            preview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            preview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
        ])
    }
    
    func configure(with: MemoListTableViewCellProperty) {
        setUpTableViewCell()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        title.text = "title"
        writedDate.text = "writedDate"
        preview.text = "preview"
    }
}
