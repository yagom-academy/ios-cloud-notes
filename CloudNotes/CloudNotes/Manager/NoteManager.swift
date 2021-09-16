//
//  NoteUpdatable.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/08.
//

import UIKit
import CoreData

class NoteManager: NSObject {
    private let coreDataStack = CoreDataStack(modelName: CoreData.modelName)
    
    var count: Int {
        return fetchedResultsController.sections?[.zero].numberOfObjects ?? 0
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Note.lastModified), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: coreDataStack.context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        return fetchedResultsController
    }()
}

extension NoteManager: NoteUpdater {    
    func createNote() {
        let newNote = Note(context: coreDataStack.context)
        newNote.title = String.empty
        newNote.body = String.empty
        newNote.lastModified = Date().timeIntervalSince1970
        coreDataStack.saveContext()
    }

    func updateNote(at indexPath: IndexPath,
                    with noteData: (title: String, body: String, lastModified: Double)) {
        let noteToUpdate = fetchedResultsController.object(at: indexPath)
        noteToUpdate.title = noteData.title
        noteToUpdate.body = noteData.body
        noteToUpdate.lastModified = noteData.lastModified
        
        coreDataStack.saveContext()
    }

    func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = fetchedResultsController.object(at: indexPath)
        coreDataStack.context.delete(noteToDelete)
        coreDataStack.saveContext()
        NotificationCenter.default.post(name: .deleteNotification, object: nil)
    }
}

extension Notification.Name {
    static let deleteNotification = Notification.Name("deleteNotification")
}
