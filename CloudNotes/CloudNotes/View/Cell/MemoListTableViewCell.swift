import UIKit

class MemoListTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    let shortBodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .gray
        return label
    }()
    
    let lastModifiedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()

    let contentsContainerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        configureContentsContainerView()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureContentsContainerView() {
        contentsContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentsContainerView.addSubview(titleLabel)
        contentsContainerView.addSubview(shortBodyLabel)
        contentsContainerView.addSubview(lastModifiedDateLabel)
        contentView.addSubview(contentsContainerView)
    }
    
    private func setAutoLayout() {
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentsContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentsContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            
            lastModifiedDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lastModifiedDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            lastModifiedDateLabel.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            
            shortBodyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: lastModifiedDateLabel.trailingAnchor, constant: 40),
            shortBodyLabel.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            shortBodyLabel.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor),
            shortBodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    func setLabels(memo: Memo) {
        titleLabel.text = memo.title
        shortBodyLabel.text = memo.body
        lastModifiedDateLabel.text = memo.lastModifiedDate
    }
}
