//
//  MessengerBetweenController.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/07.
//

import Foundation

protocol MessengerForDetailViewController {
    func deleteMemo()
    func updateListViewController(with memo: Memo?)
    func showListViewController()

}

protocol MessengerForListViewController {
    func showDetailViewController(with memo: Memo?)
    func updateMemo(_ memo: Memo, at index: Int)
    func createMemo(with memo: Memo)
    func deleteMemo(at index: Int)
}

typealias MessengerBetweenController = MessengerForListViewController & MessengerForDetailViewController
