import UIKit

protocol Reusable: class {}
 
extension Reusable where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
 
extension UITableViewCell: Reusable {}

class MemoTableViewCell: UITableViewCell {
    //MARK: - Views
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = false
        label.textColor = .label
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontSizeToFitWidth = false
        label.textColor = .label
        return label
    }()
    private let describingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontSizeToFitWidth = false
        label.textColor = .secondaryLabel
        return label
    }()
    private let dateAndDescribingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let memoListStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    func configure(with model: Memo?) {
        titleLabel.text = model?.title
        if let lastModified = model?.lastModified {
            let timeInterval = TimeInterval(lastModified)
            let dateFormatter = DateFormatter().makeLocaleDateFormatter()
            let date = dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
            dateLabel.text = "\(date)"
        }
        if let body = model?.body {
            let index = body.firstIndex(of: "\n") ?? body.endIndex
            let bodyToShow = body[..<index]
            describingLabel.text = "\(bodyToShow)"
        }
    }
    
    private func setupViews() {
        dateAndDescribingStackView.addArrangedSubview(dateLabel)
        dateAndDescribingStackView.addArrangedSubview(describingLabel)
        memoListStackView.addArrangedSubview(titleLabel)
        memoListStackView.addArrangedSubview(dateAndDescribingStackView)
        contentView.addSubview(memoListStackView)
        contentView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            memoListStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memoListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            memoListStackView.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor),
            memoListStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        nextButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

