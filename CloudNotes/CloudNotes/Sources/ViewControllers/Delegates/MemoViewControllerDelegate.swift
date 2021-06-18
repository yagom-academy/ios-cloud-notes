//
//  MemoViewControllerDelegate.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/18.
//

protocol MemoViewControllerDelegate: AnyObject {

    func memoViewController(_ memoViewController: MemoViewController, didChangeMemoAt row: Int)

}
