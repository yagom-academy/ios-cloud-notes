//
//  PrimaryTableViewCell.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/02.
//

import UIKit

class PrimaryTableViewCell: UITableViewCell {
    static let dateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter
    }()
    
    var summaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
                
        self.addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: textLabel?.bottomAnchor ?? self.contentView.topAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                  constant: self.contentView.bounds.width / 5 * 2),
            summaryLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PrimaryTableViewCell {
    func configure(by memo: MemoModel) {
        if memo.lastModified == 0 {
            self.textLabel?.text = Strings.Cell.newTitle.description
            self.detailTextLabel?.text = PrimaryTableViewCell.dateformatter.string(from: Date())
            self.summaryLabel.text = Strings.Cell.newSummary.description
        } else {
            let dateString = convertDateString(from: memo.lastModified)
            let summary = convertSummary(from: memo.body)
            self.textLabel?.text = memo.title
            self.detailTextLabel?.text = dateString
            summaryLabel.text = summary
        }
    }
    
    func convertDateString(from timeStamp: Double) -> String {
        let date: Date = Date(timeIntervalSince1970: timeStamp)
        let dateString: String = PrimaryTableViewCell.dateformatter.string(from: date)
        return dateString
    }
    
    func convertSummary(from body: String) -> String {
        let endIndex = body.firstIndex(of: "\n") ?? body.endIndex
        let summary: String = String(body.prefix(upTo: endIndex))
        return summary
    }
}
