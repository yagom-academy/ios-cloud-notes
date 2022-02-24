import UIKit

final class MemoListTableViewCell: UITableViewCell {
    static let identifier = String(describing: self)
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    private let secondaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        
        return stackView
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        
        return label
    }()
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            titleLabel.textColor = .white
            dateLabel.textColor = .white
            previewLabel.textColor = .white
        } else {
            titleLabel.textColor = .label
            dateLabel.textColor = .label
            previewLabel.textColor = .systemGray
        }
    }
    
    func setupLabel(from memo: Memo) {
        if memo.title == nil || memo.title?.isEmpty == true {
            titleLabel.text = LocalizedString.newMemoTitle
        } else {
            titleLabel.text = memo.title
        }
        dateLabel.text = memo.convertedDate
        previewLabel.text = memo.body
    }
    
    private func setupCell() {
        accessoryType = .disclosureIndicator
        configureStackView()
        configureListCellAutoLayout()
        configureSelectedBackgroundView()
    }
    
    private func configureStackView() {
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(secondaryStackView)
        secondaryStackView.addArrangedSubview(dateLabel)
        secondaryStackView.addArrangedSubview(previewLabel)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureListCellAutoLayout() {
        cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        previewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private func configureSelectedBackgroundView() {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 10
        backgroundView.backgroundColor = .systemBlue
        selectedBackgroundView = backgroundView
    }
}
