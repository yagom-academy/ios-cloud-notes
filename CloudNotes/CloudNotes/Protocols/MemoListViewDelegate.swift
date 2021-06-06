//
//  MemoListViewDelegate.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/04.
//
import UIKit

protocol MemoListViewDelegate: class {
    func updateMemo(indexPath: IndexPath)
    func deleteMemo(indexPath: IndexPath)
}
