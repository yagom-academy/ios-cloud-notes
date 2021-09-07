//
//  MemoCustomCell.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/06.
//

import UIKit

class MemoCustomCell: UITableViewCell {
    
    private let cellIdentifier = "CustomCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: cellIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
