//
//  SplitViewDelegate.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/04.
//
import UIKit

protocol MemoManagerDelegate: class {
    func memoDidCreated(createdMemo: Memo, createdMemoIndexPath: IndexPath)
    func memoDidUpdated(updatedMemoIndexPath: IndexPath)
    func memoDidDeleted(deletedMemoIndexPath: IndexPath)
    func showAlert(alert: UIAlertController)
}
