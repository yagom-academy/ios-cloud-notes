//
//  MemoProviderDelegate.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/17.
//

import Foundation

protocol MemoProviderDelegate {
  func memoDidCreate(_ memo: Memo, indexPath: IndexPath)
  func memoDidUpdate(indexPath: IndexPath, title: String, body: String)
  func memoDidDelete(indexPath: IndexPath)
}
