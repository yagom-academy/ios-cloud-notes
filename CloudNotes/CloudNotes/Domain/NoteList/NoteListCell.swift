import UIKit

class NoteListCell: UITableViewCell {

    // MARK: - View Component

    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 4

        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .systemGray2
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    private func commonInit() {
        self.accessoryType = .disclosureIndicator
        configureHierarchy()
        configureConstraints()
    }

    // MARK: - Configure Views

    func configureContent(for note: Content) {
        self.titleLabel.text = note.title == "" ? "새로운 메모" : note.title
        self.dateLabel.text = note.formattedDateString
        self.previewLabel.text = note.body == "" ? "추가 텍스트 없음" : note.body
    }

    private func configureHierarchy() {
        self.contentView.addSubview(self.cellStackView)
        self.cellStackView.addArrangedSubview(self.titleLabel)
        self.cellStackView.addArrangedSubview(self.contentStackView)
        self.contentStackView.addArrangedSubview(self.dateLabel)
        self.contentStackView.addArrangedSubview(self.previewLabel)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            self.cellStackView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor,
                constant: 10
            ),
            self.cellStackView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -10
            ),
            self.cellStackView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor,
                constant: 18
            ),
            self.cellStackView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor,
                constant: -2
            )
        ])

        self.previewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
