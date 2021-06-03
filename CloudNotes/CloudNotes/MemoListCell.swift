//
//  MemoListCell.swift
//  CloudNotes
//
//  Created by TORI on 2021/06/03.
//

import UIKit

class MemoListCell: UITableViewCell {
    
    let title = UILabel()
    let date = UILabel()
    let preview = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setLabelAttribute()
        setLabelConstraints()
    }

    func setLabelAttribute() {
        title.text = "title"
        date.text = "2021. 06. 03"
        preview.text = "preview"
    }
    
    func setLabelConstraints() {
        self.addSubview(title)
        self.addSubview(date)
        self.addSubview(preview)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        preview.translatesAutoresizingMaskIntoConstraints = false
        
        let titleConstraints = ([
            title.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        let dateConstraints = ([
            date.topAnchor.constraint(equalTo: title.safeAreaLayoutGuide.bottomAnchor),
            date.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            date.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        let previewConstraints = ([
            preview.topAnchor.constraint(equalTo: title.safeAreaLayoutGuide.bottomAnchor),
            preview.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            preview.leadingAnchor.constraint(equalTo: date.safeAreaLayoutGuide.trailingAnchor),
            preview.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(dateConstraints)
        NSLayoutConstraint.activate(previewConstraints)
    }

}
