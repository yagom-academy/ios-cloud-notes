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
    var lastModifiedDate = UILabel()
    var body = UILabel()
      
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
        self.contentView.addSubview(body)
        self.contentView.addSubview(lastModifiedDate)
    }
    
    private func setUpTitleLabel(layoutGuide: UILayoutGuide) {
        title.font = title.font.withSize(25)
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: lastModifiedDate.topAnchor, constant: -5),
        ])
    }
    
    private func setUpWritedDateLabel(layoutGuide: UILayoutGuide) {
        lastModifiedDate.textColor = .black
        lastModifiedDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastModifiedDate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            lastModifiedDate.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            lastModifiedDate.trailingAnchor.constraint(equalTo: body.leadingAnchor, constant: -50),
            lastModifiedDate.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    private func setUpPreviewLabel(layoutGuide: UILayoutGuide) {
        body.textColor = .systemGray
        body.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: lastModifiedDate.topAnchor, constant: 0),
            body.leadingAnchor.constraint(equalTo: lastModifiedDate.trailingAnchor, constant: 10),
            body.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(with memo: Memo) {
        setUpUI()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        title.text = memo.title
        body.text = memo.body
        lastModifiedDate.text = memo.getLastModified()
    }
}
