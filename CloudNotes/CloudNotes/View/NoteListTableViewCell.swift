import UIKit

class NoteListTableViewCell: UITableViewCell {
    
    private let primaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    private let supplementaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let lastModifiedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .systemGray
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        primaryStackView.addArrangedSubview(titleLabel)
        primaryStackView.addArrangedSubview(supplementaryStackView)
        
        supplementaryStackView.addArrangedSubview(lastModifiedLabel)
        supplementaryStackView.addArrangedSubview(bodyLabel)
        
        contentView.addSubview(primaryStackView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            primaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            primaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            primaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            primaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
        
        lastModifiedLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        bodyLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        accessoryType = .disclosureIndicator
    }
    
    func setLabelText(title: String, body: String, lastModified: String) {
        titleLabel.text = title
        bodyLabel.text = body
        lastModifiedLabel.text = lastModified
    }
    
}

extension NoteListTableViewCell: TypeNameConvertible {}
