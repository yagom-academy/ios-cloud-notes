//
//  MemoProviderDelegate.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/17.
//

import UIKit

protocol MemoProviderDelegate {
  func memoDidCreate(_ memo: Memo, indexPath: IndexPath)
  func memoDidUpdate(indexPath: IndexPath)
  func memoDidDelete(indexPath: IndexPath)
  func presentAlertController(_ alert: UIAlertController)
}
