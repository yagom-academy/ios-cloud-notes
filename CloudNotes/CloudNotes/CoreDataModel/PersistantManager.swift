//
//  PersistantManager.swift
//  CloudNotes
//
//  Created by 이호영 on 2022/02/16.
//

import Foundation
import CoreData

class PersistantManager {
    lazy var notes: [Note] = setupNotes()
    
    private func setupNotes() -> [Note] {
        return []
    }
    
    func save(noteInformation: NoteInformation) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
                
        let object = NSEntityDescription.insertNewObject(
            forEntityName: "Note",
            into: context
        )
        object.setValue(noteInformation.title, forKey: "title")
        object.setValue(noteInformation.content, forKey: "content")
        object.setValue(noteInformation.lastModifiedDate, forKey: "lastModifiedDate")
    }
}
