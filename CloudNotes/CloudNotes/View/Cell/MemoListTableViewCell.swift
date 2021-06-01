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
    
    private func setUpUI() {
        let safeArea = self.contentView.safeAreaLayoutGuide
        self.addSubviewInContentView()
        self.setUpTitleLabel(layoutGuide: safeArea)
        self.setUpWritedDateLabel(layoutGuide: safeArea)
        self.setUpPreviewLabel(layoutGuide: safeArea)
    }
    
    private func addSubviewInContentView() {
        self.contentView.addSubview(title)
        self.contentView.addSubview(preview)
        self.contentView.addSubview(writedDate)
    }
    
    private func setUpTitleLabel(layoutGuide: UILayoutGuide) {
        title.font = title.font.withSize(25)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: writedDate.topAnchor, constant: -5),
        ])
    }
    
    private func setUpWritedDateLabel(layoutGuide: UILayoutGuide) {
        writedDate.textColor = .black
        writedDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            writedDate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            writedDate.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            writedDate.trailingAnchor.constraint(equalTo: preview.leadingAnchor, constant: -50),
            writedDate.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    private func setUpPreviewLabel(layoutGuide: UILayoutGuide) {
        preview.textColor = .systemGray
        preview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: writedDate.topAnchor, constant: 0),
            preview.leadingAnchor.constraint(equalTo: writedDate.trailingAnchor, constant: 10),
            preview.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(with: Memo) {
        setUpUI()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        title.text = "titletitletitletitletitletitletitletitletitletitletitletitletitletitle"
        writedDate.text = "2021.01.23"
        preview.text = "titletitletitletitletitletitletitletitletitletitletitletitletitletitle"
    }
}
