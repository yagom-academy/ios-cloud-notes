//
//  MemoManageable.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/15.
//

import UIKit

typealias MemoManageable = MemoSplitViewManageable & CoreDataManageable & DropboxManageable

protocol CoreDataManageable: AnyObject {
    var isMemosEmpty: Bool { get }
    var memosCount: Int { get }
    
    func create()
    func fetchAll()
    func fetch(at indexPath: IndexPath) -> Memo
    func delete(at indexPath: IndexPath)
    func update(at indexPath: IndexPath, title: String, body: String)
}

protocol DropboxManageable: AnyObject {
    func connectDropbox(viewController: UIViewController)
    func upload(at indexPath: IndexPath)
}

protocol MemoSplitViewManageable: AnyObject {
    func showPrimaryView()
    func showSecondaryView(of indexPath: IndexPath)
    func presentConnectResultAlert(type: AlertMessage)
    func presentShareActivity(at indexPath: IndexPath)
    func presentDeleteAlert(at indexPath: IndexPath)
    func reloadRow(at indexPath: IndexPath, title: String, body: String)
}
