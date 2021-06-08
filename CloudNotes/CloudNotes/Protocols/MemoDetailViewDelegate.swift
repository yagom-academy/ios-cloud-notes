//
//  MemoDetailViewDelegate.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/08.
//

import Foundation

protocol MemoDetailViewDelegate: class {
    func setUpData(memo: Memo, indexPath: IndexPath)
    func clearField()
}
