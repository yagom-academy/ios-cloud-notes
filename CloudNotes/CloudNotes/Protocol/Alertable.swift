//
//  Alertable.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/15.
//

import Foundation

protocol Alertable: AnyObject {
    func showActionSheet(of indexPath: IndexPath, noteTitle: String, deleteHandler: @escaping () -> Void)
    func showActivityView(of indexPath: IndexPath, noteTitle: String)
    func showDeleteAlert(of indexPath: IndexPath, deleteHandler: @escaping () -> Void)
}
