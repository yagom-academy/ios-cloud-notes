import UIKit

class NoteListTableViewCell: UITableViewCell {
    private var titleLabel: UILabel = {
       var label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateLabel: UILabel = {
        var label = UILabel()
         label.font = .preferredFont(forTextStyle: .title2)
         label.numberOfLines = 0
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    private var previewLabel: UILabel = {
        var label = UILabel()
         label.font = .preferredFont(forTextStyle: .title2)
         label.numberOfLines = 0
         label.textAlignment = .center
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()
    
    private lazy var textHorizontalStackView: UIStackView = {
       var stackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var textVerticalStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [titleLabel, textHorizontalStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(textVerticalStackView)
        setUpLayout()
    }
    
    func updateLabel(param: Sample) {
        updateTitleLabel(with: param.title)
        updateDateLabel(with: param.lastModified)
        updatePreviewLabel(with: param.body)
    }
    
    func updateTitleLabel(with name: String) {
        titleLabel.text = name
    }
    
    func updateDateLabel(with date: Int) {
        dateLabel.text = date.description
    }
    
    func updatePreviewLabel(with preview: String) {
        previewLabel.text = String(preview.prefix(6))
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            textVerticalStackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            textVerticalStackView.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            textVerticalStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textVerticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
