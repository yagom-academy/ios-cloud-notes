//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel!
    private var dateLabel: UILabel!
    private var previewLabel: UILabel!
    
    private lazy var dateAndPreviewStackView: UIStackView = {
        let dateAndPreviewStackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])
        
        dateAndPreviewStackView.translatesAutoresizingMaskIntoConstraints = false
        dateAndPreviewStackView.axis = .horizontal
        dateAndPreviewStackView.spacing = 8
        dateAndPreviewStackView.distribution = .fillEqually
        
        return dateAndPreviewStackView
    }()
    
    private lazy var titleWithDetailStackView: UIStackView = {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, dateAndPreviewStackView])
        
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .vertical
        titleStackView.spacing = 8
        titleStackView.distribution = .fillEqually
        
        return titleStackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabelsUp()
        contentView.addSubview(titleWithDetailStackView)
        setStackViewAnchor()
        
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setLabelsUp() {
        titleLabel = UILabel()
        dateLabel = UILabel()
        previewLabel = UILabel()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.lineBreakMode = .byTruncatingTail
        
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.lineBreakMode = .byTruncatingTail
        
        previewLabel.font = UIFont.preferredFont(forTextStyle: .body)
        previewLabel.adjustsFontForContentSizeCategory = true
        previewLabel.lineBreakMode = .byTruncatingTail
    }
    
    private func setStackViewAnchor() {
        titleWithDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleWithDetailStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16)
            .isActive = true
        titleWithDetailStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
            .isActive = true
        titleWithDetailStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
            .isActive = true
        titleWithDetailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
            .isActive = true
    }
    
    func configureLabels(withModel: Savable) {
        titleLabel.text = withModel.title
        dateLabel.text = withModel.lastModified?.description
        previewLabel.text = withModel.body
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
