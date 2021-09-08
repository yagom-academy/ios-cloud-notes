//
//  SplitViewDelegate.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/03.
//

import Foundation

protocol MemoListDelegate: NSObject {
    var isFisrtCellSelection: Bool { set get }
    
    func showDetail(data: Memo, index: IndexPath)
}

protocol DetailMemoDelegate: NSObject {
    func saveMemo(with newMemo: Memo, index: IndexPath)
}
