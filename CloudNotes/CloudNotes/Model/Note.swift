//
//  Note.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/09.
//

import Foundation
import CoreData

struct Note {
    let title: String?
    let body: String?
    var lastModify: String?
    var objectID: NSManagedObjectID?
}
