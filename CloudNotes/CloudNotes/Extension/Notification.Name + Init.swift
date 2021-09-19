//
//  Notification.Name + Init.swift
//  CloudNotes
//
//  Created by Theo on 2021/09/19.
//

import Foundation

extension Notification.Name {
    enum Notifications: String {
        case newMemoDidInput
        case memoDidUpdate
        case memoDidDelete
    }

    init(_ notification: Notifications) {
        self = Notification.Name(notification.rawValue)
    }
}
