//
//  MemoManageable.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/15.
//

import UIKit

typealias MemoManageable = MemoSplitViewManageable & MemoStorageManageable

protocol MemoStorageManageable: AnyObject {
    var isMemoStorageEmpty: Bool { get }
    var memosCount: Int { get }
    
    func create()
    func fetchAll()
    func fetch(at indexPath: IndexPath) -> Memo
    func delete(at indexPath: IndexPath)
    func update(at indexPath: IndexPath, title: String, body: String)
    
    func connectDropbox(viewController: UIViewController)
}

protocol MemoSplitViewManageable: AnyObject {
    func showPrimaryView()
    func showSecondaryView(of indexPath: IndexPath)
    func presentShareActivity(at indexPath: IndexPath)
    func presentDeleteAlert(at indexPath: IndexPath)
    func reloadRow(at indexPath: IndexPath, title: String, body: String)
}
