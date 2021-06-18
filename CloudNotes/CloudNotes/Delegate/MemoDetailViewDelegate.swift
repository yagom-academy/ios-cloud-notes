//
//  File.swift
//  CloudNotes
//
//  Created by 이영우 on 2021/06/17.
//

import Foundation

protocol MemoDetailViewDelegate {
  func textViewDidChanged(indexPath: IndexPath, title: String, body: String)
  func touchDeleteButton(indexPath: IndexPath)
  func touchShareButton(indexPath: IndexPath)
}
