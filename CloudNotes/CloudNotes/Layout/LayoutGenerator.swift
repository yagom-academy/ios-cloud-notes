//
//  LayoutGenerator.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/02.
//

import UIKit

struct SetLayout {
    static func setupTableView(_ tableView: UITableView, _ superView: UIView) {
        superView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
    }
}
