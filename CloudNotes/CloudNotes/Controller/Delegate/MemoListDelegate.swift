//
//  SplitViewDelegate.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/03.
//

import Foundation

protocol MemoListDelegate: AnyObject {
    var isFirstCellSelection: Bool { set get }
    
    func showDetail(data: Memo, index: IndexPath)
}

protocol DetailMemoDelegate: AnyObject {
    func saveMemo(with newMemo: Memo, index: IndexPath)
    func deleteMemo(index: IndexPath)
}
