//
//  MessengerBetweenController.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/07.
//

import Foundation

protocol MessengerBetweenController {
    func showDetailViewController(with memo: Memo?)
    func updateListViewController(with memo: Memo?)
    func showListViewController()

    func updateMemo(_ memo: Memo, at index: Int)
    func createMemo(with memo: Memo)
}
