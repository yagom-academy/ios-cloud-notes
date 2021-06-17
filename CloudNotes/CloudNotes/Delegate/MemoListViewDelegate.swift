//
//  MemoListViewDelegate.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/17.
//

import Foundation

protocol MemoListViewDelegate {
  func touchAddButton()
  func touchDeleteButton(indexPath: IndexPath)
  func touchShareButton(indexPath: IndexPath)
}
