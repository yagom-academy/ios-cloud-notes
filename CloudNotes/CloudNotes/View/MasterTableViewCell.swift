import UIKit

final class MasterTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let dateAndPreviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .lightGray
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = .autoupdatingCurrent
        
        return dateFormatter
    }()
    
    // MARK: - Methods
    func configureUI() {
        configureLabels()
        accessoryType = .disclosureIndicator
        let bgView = UIView()
        bgView.backgroundColor = .systemBlue
        selectedBackgroundView = bgView
    }
    
    private func configureLabels() {
        contentView.addSubview(entireStackView)
        entireStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        entireStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        entireStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        entireStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        entireStackView.addArrangedSubview(titleLabel)
        dateAndPreviewStackView.addArrangedSubview(dateLabel)
        dateAndPreviewStackView.addArrangedSubview(previewLabel)
        entireStackView.addArrangedSubview(dateAndPreviewStackView)
        
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        previewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    func applyData(_ data: Memo) {
        self.titleLabel.text = data.title
        let date = Date(timeIntervalSince1970: data.lastModifiedDate)
        self.dateLabel.text = dateFormatter.string(from: date)
        self.previewLabel.text = data.body
    }
}
