//
//  SplitViewController+ShowDetailDelegate.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/13.
//

import Foundation

protocol CustomSplitViewDelegate: AnyObject {
    func showDetailViewController(_ memo: MemoEntity)
}
