//
//  SplitViewDelegate.swift
//  CloudNotes
//
//  Created by Kim Do hyung on 2021/09/03.
//

import Foundation

protocol SplitViewDelegate: NSObject {
    var isFisrtCellSelection: Bool { set get }
    
    func selectCell(data: Memo, index: IndexPath)
    func addMemo(data: Memo)
}

protocol Memorizable: NSObject {
    func saveMemo(with newMemo: Memo, index: IndexPath)
}
