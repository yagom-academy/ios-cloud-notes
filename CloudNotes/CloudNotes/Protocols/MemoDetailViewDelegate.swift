//
//  MemoDetailViewDelegate.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/08.
//

import UIKit

protocol MemoDetailViewDelegate: class {
    func memoAddButtonDidTapped()
    func memoTitleTextViewDidChanged(memoIndexPathToUpdate: IndexPath, text: String)
    func memoDescriptionTextViewDidChanged(memoIndexPathToUpdate: IndexPath, text: String)
    func memoDeleteButtonDidTapped(memoIndexPath: IndexPath)
    func memoShareButtonDidTapped(memoIndexPathToShare: IndexPath, sourceView: UIView)
    func showAlert(alert: UIAlertController)
}
