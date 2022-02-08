import UIKit

class NoteListCell: UITableViewCell {
    static let reuseIdentifer: String = "cell"
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill

        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        //label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left

        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray2
        label.adjustsFontForContentSizeCategory = true
        //label.lineBreakMode = .byTruncatingTail

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureHierarchy()
        configureConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Configure Views
    func configureHierarchy() {
        self.contentView.addSubview(cellStackView)
        self.cellStackView.addArrangedSubview(titleLabel)
        self.cellStackView.addArrangedSubview(contentStackView)
        self.contentStackView.addArrangedSubview(dateLabel)
        self.contentStackView.addArrangedSubview(previewLabel)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            self.cellStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.cellStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.cellStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.cellStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        self.titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}
