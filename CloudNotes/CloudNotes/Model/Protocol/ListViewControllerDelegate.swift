//
//  ListViewControllerDelegate.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/04.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
  func didTapMenuItem(model memoInfo: MemoInfo)
  
  func didSwipeForDeleteMenuItem(
    model memoInfo: MemoInfo,
    completion: @escaping () -> Void
  )
}
