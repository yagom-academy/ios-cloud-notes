//
//  NotificationNames.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/09.
//

import Foundation

enum NotificationNames: String {
    case delete = "delete"
    case update = "update"
    
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
