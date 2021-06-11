//
//  MemoListViewDelegate.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/04.
//
import UIKit

protocol MemoListViewDelegate: class {
    func memoAddButtonDidTapped()
    func memoDeleteButtonDidTapped(memoIndexPath: IndexPath)
    func memoShareButtonDidTapped(memoIndexPathToShare: IndexPath, sourceView: UIView)
    func didSelectRow(at indexPath: IndexPath)
    func showAlert(alert: UIAlertController)
}
