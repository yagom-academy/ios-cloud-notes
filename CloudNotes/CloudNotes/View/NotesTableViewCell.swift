//
//  NotesTableViewCell.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    private var titleLabel = UILabel()
    private var lastModifiedLabel = UILabel()
    private var bodyLabel = UILabel()
    
    enum Constraints {
        static let innerStackViewSpacing: CGFloat = 25
        static let outerStackViewLeadingInset: CGFloat = 10
        static let outerStackViewTrailingInset: CGFloat = -10
        static let outerStackViewTopInset: CGFloat = 5
        static let outerStackViewBottomInset: CGFloat = -5
        static let portraitSeparatorInset: CGFloat = 10
        static let landscapeSeparatorInset: CGFloat = 140
    }
    
    private var innerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = Constraints.innerStackViewSpacing
        stackView.distribution = .fill
        stackView.alignment = .lastBaseline
        
        return stackView
    }()
    
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor,
                        constant: Constraints.outerStackViewLeadingInset).isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor,
                        constant: Constraints.outerStackViewTrailingInset).isActive = true
        stackView.topAnchor
            .constraint(equalTo: contentView.topAnchor,
                        constant: Constraints.outerStackViewTopInset).isActive = true
        stackView.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor,
                        constant: Constraints.outerStackViewBottomInset).isActive = true

        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        separatorInset.left = {
            return UIDevice.current.orientation == .portrait
                ? Constraints.portraitSeparatorInset
                : Constraints.landscapeSeparatorInset
        }()
    }
    
    func initCell(with note: Note) {
        initCellLayout()
        initCellStyle()
        initCellContent(with: note)
    }
    
    private func initCellLayout() {
        outerStackView.addArrangedSubview(titleLabel)
        outerStackView.addArrangedSubview(innerStackView)
        
        innerStackView.addArrangedSubview(lastModifiedLabel)
        innerStackView.addArrangedSubview(bodyLabel)

        lastModifiedLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func initCellStyle() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        lastModifiedLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        bodyLabel.textColor = .gray
        self.accessoryType = .disclosureIndicator
    }
}

extension NotesTableViewCell: DateFormattable {
    private func initCellContent(with note: Note) {
        titleLabel.text = note.title
        bodyLabel.text = note.body
        lastModifiedLabel.text = format(lastModified: note.lastModified)
    }
}
