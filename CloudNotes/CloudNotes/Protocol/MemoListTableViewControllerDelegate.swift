//
//  MemoListTableViewControllerDelegate.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/08.
//

import UIKit

protocol MemoListTableViewControllerDelegate: AnyObject {
    func didTapMemo(_ vc: UITableViewController, memo: String)
}
