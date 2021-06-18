//
//  MemoListViewControllerDelegate.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/18.
//

protocol MemoListViewControllerDelegate: AnyObject {

    func memoListViewControllerWillHideMemo(_ memoListViewController: MemoListViewController)
    func memoListViewController(_ memoListViewController: MemoListViewController, willShowMemoAt row: Int)

}
