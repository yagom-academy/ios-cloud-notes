//
//  NotesTableViewCell.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import UIKit

class NoteCell: UITableViewCell {
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
        NSLayoutConstraint.activate([
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: Constraints.outerStackViewLeadingInset),
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: Constraints.outerStackViewTrailingInset),
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: Constraints.outerStackViewTopInset),
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: Constraints.outerStackViewBottomInset)
        ])

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

extension NoteCell {
    enum NotePlacholder {
        static let title = "제목"
        static let body = "내용이 비어있습니다"
    }
    
    private func initCellContent(with note: Note) {
        let dateFormatter = DateFormatter()
        titleLabel.text = note.title.isEmpty ? NotePlacholder.title : note.title
        bodyLabel.text = note.body.isEmpty ? NotePlacholder.body : note.body
        lastModifiedLabel.text = dateFormatter.formatToCurrent(lastModified: note.lastModified)
    }
}
