//
//  MemoChangeHandleable.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/08.
//

import Foundation

protocol MemoChangeHandleable: AnyObject {
    func processModified(data memoItem: Memo)
}
