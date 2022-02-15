//
//  MemoManageable.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/15.
//

import Foundation

typealias MemoManageable = MemoSplitViewManageable & MemoStorageManageable

protocol MemoStorageManageable: AnyObject {
    var isMemoStorageEmpty: Bool { get }
    var memosCount: Int { get }
    
    func create()
    func fetchAll()
    func fetch(at indexPath: IndexPath) -> Memo
    func delete(at indexPath: IndexPath)
}

protocol MemoSplitViewManageable: AnyObject {
    func showPrimaryView()
    func showSecondaryView(of indexPath: IndexPath)
    func presentShareActivity(at indexPath: IndexPath)
    func presentDeleteAlert(at indexPath: IndexPath)
}
