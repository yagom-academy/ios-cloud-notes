//
//  NoteListTableViewCell.swift
//  CloudNotes
//
//  Created by JeongTaek Han on 2022/02/10.
//

import UIKit

class NoteListTableViewCell: UITableViewCell {
    
    let primaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    let supplementaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastModifiedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureHierarchy()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        
        NSLayoutConstraint.activate([
            primaryStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            primaryStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            primaryStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            primaryStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.accessoryType = .disclosureIndicator
    }
    
    private func configureHierarchy() {
        primaryStackView.addArrangedSubview(titleLabel)
        primaryStackView.addArrangedSubview(supplementaryStackView)
        
        supplementaryStackView.addArrangedSubview(lastModifiedLabel)
        supplementaryStackView.addArrangedSubview(bodyLabel)
        
        self.addSubview(primaryStackView)
    }

}
