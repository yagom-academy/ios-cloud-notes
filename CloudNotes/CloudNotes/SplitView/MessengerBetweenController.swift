//
//  MessengerBetweenController.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/07.
//

import Foundation

protocol MessengerBetweenController {
    func showDetailViewController(with memo: Memo?)
    func showListViewController(with memo: Memo?)
}
