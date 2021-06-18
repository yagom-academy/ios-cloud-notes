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
    
    override func prepareForReuse() {
        title.text = ""
        lastModifiedDate.text = ""
        body.text = ""
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
        title.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 5), // Cell의 safeArea의 Top과의 거리를 임의로 5로 설정함
            title.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10), // Cell의 safeArea의 leading과의 거리를 임의로 10으로 설정함
            title.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10), // Cell의 safeArea의 trailing과의 거리를 임의로 -10으로 설정함
            title.bottomAnchor.constraint(equalTo: lastModifiedDate.topAnchor, constant: -5), // lastModifiedDate Label의 Top과의 거리를 임의로 -5로 설정함
        ])
    }
    
    private func setUpWritedDateLabel(layoutGuide: UILayoutGuide) {
        lastModifiedDate.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        lastModifiedDate.textColor = .label
        lastModifiedDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastModifiedDate.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5), // title Label의 Bottom과의 거리를 임의로 5로 설정함
            lastModifiedDate.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10), // Cell의 safeArea의 Leading과의 거리를 임의로 10으로 설정함
            lastModifiedDate.trailingAnchor.constraint(equalTo: body.leadingAnchor, constant: 0), // body Label의 Leading과 Cell의 safeArea의 Leading과의 거리를 lastModifiedDate의 크기를 고려하여 150으로 설정하였으므로 body Label의 Leading과의 거리를 0으로 설정함
            lastModifiedDate.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -5), // Cell의 safeArea의 Bottom과의 거리를 임의로 -5로 설정함
        ])
    }
    
    private func setUpPreviewLabel(layoutGuide: UILayoutGuide) {
        body.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        body.textColor = .systemGray
        body.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: lastModifiedDate.topAnchor, constant: 0), // lastModifiedDate Label의 Top과의 높이를 동일하게 해주기 위해서 0으로 설정함
            body.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 150), // Cell의 safeArea의 Leading과의 거리를 lastModifiedDate의 크기를 고려해서 150으로 설정함
            body.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10), // Cell의 safeArea의 Trailing과의 거리를 임의로 -10으로 설정함
        ])
    }
    
    func configure(with memo: MemoListItem) {
        setUpUI()
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        guard let lastModified = memo.lastModifiedDate else {
            return
        }
        title.text = memo.title
        lastModifiedDate.text = formattedLastModifiedDate(date: lastModified)
        body.text = memo.body
    }
    
    private func formattedLastModifiedDate(date: Date) -> String {
        let currentLocale = Locale.current.collatorIdentifier ?? "ko_KR"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: currentLocale)
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy. MM. dd.")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        return dateFormatter.string(from: date)
    }
}
