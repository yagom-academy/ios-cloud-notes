//
//  MemoListDelegate.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/08.
//

import Foundation

protocol MemoListDelegate: AnyObject {
    func didTapTableViewCell(at indexPath: IndexPath)
    func didTapAddButton()
    func didTapDeleteButton(at indexPath: IndexPath)
    func didTapShareButton(at indexPath: IndexPath)
}
