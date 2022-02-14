import UIKit

class MemoListCell: UITableViewCell {
    static let identifier = "MemoListCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let insideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    private let outsideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            titleLabel.textColor = .white
            dateLabel.textColor = .systemGray6
            bodyLabel.textColor = .systemGray6
        } else {
            titleLabel.textColor = .label
            dateLabel.textColor = .systemGray
            bodyLabel.textColor = .systemGray
        }
    }
    
    func configure(with item: Memo?) {
        let data = item?.body?.split(separator: "\n")
        let title = item?.title ?? "새로운 메모"
        let body = data?[safe: 1]?.trimmingCharacters(in: ["\n", " "]) ?? "추가 텍스트 없음"
        let lastModified = item?.lastModified.formattedDate ?? Date().timeIntervalSince1970.formattedDate
        
        titleLabel.text = title
        bodyLabel.text = body
        dateLabel.text = lastModified
    }
    
    private func setUpViews() {
        contentView.addSubview(outsideStackView)
        outsideStackView.addArrangedSubview(titleLabel)
        outsideStackView.addArrangedSubview(insideStackView)
        insideStackView.addArrangedSubview(dateLabel)
        insideStackView.addArrangedSubview(bodyLabel)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .systemOrange
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            outsideStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            outsideStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            outsideStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            outsideStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
}
