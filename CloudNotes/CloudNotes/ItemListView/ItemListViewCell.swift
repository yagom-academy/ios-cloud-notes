//
//  ItemListViewCell.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/01.
//

import UIKit

class ItemListViewCell: UITableViewCell {
    static let identifier = "ItemListViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.text = "?!!!"
        
        
        label.frame.size = CGSize(
            width: contentView.bounds.width,
            height: contentView.bounds.height
        )

        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func display(_ layer: CALayer) {
        super.display(layer)
        
        print("!")
    }
}
