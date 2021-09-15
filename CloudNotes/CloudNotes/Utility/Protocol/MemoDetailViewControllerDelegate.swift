//
//  MemoDetailViewControllerDelegate.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/12.
//

import UIKit

protocol MemoDetailViewControllerDelegate: AnyObject {
    func contentsDidChanged(at indexPath: IndexPath, contetnsText: (title: String?, body: String?))
    func didTapSeeMoreButton(sender: UIBarButtonItem, at indexPath: IndexPath)
}
