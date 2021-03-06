import UIKit
import CoreData

class MemoListTableViewCell: UITableViewCell {
    let listTitleLabel: UILabel = makeLabel(textStyle: .body)
    let listShortBodyLabel: UILabel = makeLabel(textStyle: .body, textColor: .gray)
    let listLastModifiedDateLabel: UILabel = makeLabel(textStyle: .caption2)
    let contentsContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        configureContentsContainerView()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class private func makeLabel(textStyle: UIFont.TextStyle, textColor: UIColor = UIColor(named: "TextColor") ?? .gray) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: textStyle)
        label.textColor = textColor
        return label
    }

    private func configureContentsContainerView() {
        contentsContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentsContainerView.addSubview(listTitleLabel)
        contentsContainerView.addSubview(listShortBodyLabel)
        contentsContainerView.addSubview(listLastModifiedDateLabel)
        contentView.addSubview(contentsContainerView)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentsContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            listTitleLabel.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            listTitleLabel.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            listTitleLabel.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            listTitleLabel.heightAnchor.constraint(equalTo: contentsContainerView.heightAnchor, multiplier: 0.5),
            
            listLastModifiedDateLabel.leadingAnchor.constraint(equalTo: listTitleLabel.leadingAnchor),
            listLastModifiedDateLabel.topAnchor.constraint(equalTo: listTitleLabel.bottomAnchor),
            listLastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            listLastModifiedDateLabel.widthAnchor.constraint(equalTo: contentsContainerView.widthAnchor, multiplier: 0.4),
            
            listShortBodyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listLastModifiedDateLabel.trailingAnchor, constant: 40),
            listShortBodyLabel.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            listShortBodyLabel.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            listShortBodyLabel.topAnchor.constraint(equalTo: listTitleLabel.bottomAnchor)
        ])
    }
    
    func receiveLabelsText(memo: NSManagedObject) {
        let text = memo.value(forKey: "content") as? String ?? ""
        let splitedString = splitString(of: text)
        let title = splitedString.0
        let body = splitedString.1
        let lastModified = memo.value(forKey: "lastModified")
        var lastModifiedDateToString: String {
            guard let date: Date = lastModified as? Date else {
                return "No Data"
            }
            
            let dateStr = date.convertToString()
            return dateStr
        }
        
        listTitleLabel.text = (title == "") ? "새로운 메모": title
        listShortBodyLabel.text = (body == "") ? "텍스트 없음": body
        listLastModifiedDateLabel.text = lastModifiedDateToString
    }
    
    func splitString(of text: String) -> (String, String) {
        var titleText: String = ""
        var bodyText: String = ""

        let fullText = text.split(separator: "\n").map { (value) -> String in
            return String(value) }

        switch fullText.count {
        case 0:
            titleText = ""
            bodyText = ""
        case 1:
            titleText = fullText[0]
        default:
            titleText = fullText[0]
            for i in 1...(fullText.count - 1) {
                bodyText += (fullText[i] + "\n")
            }
        }
        return (titleText, bodyText)
    }
}
