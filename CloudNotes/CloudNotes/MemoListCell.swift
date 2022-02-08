import UIKit

class MemoListCell: UITableViewCell {
    static let identifier = "MemoListCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let insideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()
    
    let outsideStackView: UIStackView = {
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
    
    func setUpViews() {
        contentView.addSubview(outsideStackView)
        outsideStackView.addArrangedSubview(titleLabel)
        outsideStackView.addArrangedSubview(insideStackView)
        insideStackView.addArrangedSubview(dateLabel)
        insideStackView.addArrangedSubview(bodyLabel)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            outsideStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            outsideStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            outsideStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            outsideStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }
    
    func configure() {
        titleLabel.text = "똘기떵이호치새초미자축인묘"
        dateLabel.text = "2020.12.19."
        bodyLabel.text = "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring"
    }
}
