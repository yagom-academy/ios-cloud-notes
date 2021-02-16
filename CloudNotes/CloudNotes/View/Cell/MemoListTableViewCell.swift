import UIKit

class MemoListTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let shortBodyLabel = UILabel()
    let lastModifiedDateLabel = UILabel()
    let contentsContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        configureContents()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureContents() {
        contentsContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        shortBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        lastModifiedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.adjustsFontForContentSizeCategory = true
        shortBodyLabel.adjustsFontForContentSizeCategory = true
        lastModifiedDateLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.font = .preferredFont(forTextStyle: .body)
        shortBodyLabel.font = .preferredFont(forTextStyle: .callout)
        shortBodyLabel.font = .preferredFont(forTextStyle: .callout)
        
        lastModifiedDateLabel.textColor = .gray
        
        contentsContainerView.addSubview(titleLabel)
        contentsContainerView.addSubview(shortBodyLabel)
        contentsContainerView.addSubview(lastModifiedDateLabel)
        contentView.addSubview(contentsContainerView)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentsContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentsContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            
            lastModifiedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lastModifiedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            lastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            
            shortBodyLabel.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            shortBodyLabel.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            shortBodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
        
        let bodyLabelLeadingConstraint = shortBodyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: lastModifiedDateLabel.trailingAnchor, constant: 50)
        bodyLabelLeadingConstraint.priority = .defaultHigh
        bodyLabelLeadingConstraint.isActive = true
        
        let bodyLabelWidthConstraint = shortBodyLabel.widthAnchor.constraint(equalTo: contentsContainerView.widthAnchor, multiplier: 0.6)
        bodyLabelWidthConstraint.priority = .defaultLow
        bodyLabelLeadingConstraint.isActive = true
    }
    
    func setLabels(memo: Memo) {
        titleLabel.text = memo.title
        shortBodyLabel.text = memo.body
        lastModifiedDateLabel.text = memo.lastModifiedDate
    }
}
