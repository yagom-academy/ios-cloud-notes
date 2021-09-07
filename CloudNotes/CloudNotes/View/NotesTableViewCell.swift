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
    
    private var innerStackView: UIStackView = {
        let stackView = UIStackView()
        let innerStackViewSpacing: CGFloat = 25
        
        stackView.axis = .horizontal
        stackView.spacing = innerStackViewSpacing
        stackView.distribution = .fill
        stackView.alignment = .lastBaseline
        
        return stackView
    }()
    
    private lazy var outerStackView: UIStackView = {
        let stackView = UIStackView()
        let leadingInset: CGFloat = 10
        let trailingInset: CGFloat = -10
        let topInset: CGFloat = 5
        let bottomInset: CGFloat = -5
        
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: leadingInset).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: trailingInset).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: topInset).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: bottomInset).isActive = true
        
        return stackView
    }()
    
    func initCellLayout() {
        outerStackView.addArrangedSubview(titleLabel)
        outerStackView.addArrangedSubview(innerStackView)
        
        innerStackView.addArrangedSubview(lastModifiedLabel)
        innerStackView.addArrangedSubview(bodyLabel)

        lastModifiedLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

extension NotesTableViewCell: DateFormattable {
    func initCell(with note: Note) {
        initCellContent(with: note)
        initCellLayout()
    }
    
    func initCellContent(with note: Note) {
        titleLabel.text = note.title
        bodyLabel.text = note.body
        lastModifiedLabel.text = format(lastModified: note.lastModified)
    }

}
