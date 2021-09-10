//
//  MemoListDelegate.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/08.
//

import Foundation

protocol MemoListDelegate: AnyObject {
    func didTapTableViewCell(_ memo: Memo)
    func didTapAddButton()
}
