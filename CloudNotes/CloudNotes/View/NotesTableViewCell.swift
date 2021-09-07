//
//  NotesTableViewCell.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/07.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    private var titleLabel = UILabel()
    private var bodyLabel = UILabel()
    private var lastModifiedLabel = UILabel()
}

extension NotesTableViewCell: DateFormattable {
    func updateContents(with note: Note) {
        titleLabel.text = note.title
        bodyLabel.text = note.body
        lastModifiedLabel.text = format(lastModified: note.lastModified)
    }
}
