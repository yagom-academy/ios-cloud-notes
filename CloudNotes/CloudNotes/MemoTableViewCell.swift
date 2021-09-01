//
//  MemoTableViewCell.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/01.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var previewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
