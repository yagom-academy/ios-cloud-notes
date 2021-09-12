//
//  MemoDetailViewControllerDelegate.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/12.
//

import Foundation

protocol MemoDetailViewControllerDelegate: AnyObject {
    func contentsDidChanged(at indexPath: IndexPath, contetnsText: (title: String?, body: String?))
}
