//
//  NoteUpdatable.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/08.
//

import UIKit
import CoreData

class NoteManager {
    private var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        return app.persistentContainer.viewContext
    }
    
    private lazy var notes: [Note] = fetchNotes()
    
    var count: Int {
        return notes.count
    }
    
    func fetchNote(at index: Int) -> Note? {
        return notes[index]
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                fetchNotes()
                NotificationCenter.default.post(name: .noteNotification,
                                                object: nil,
                                                userInfo: ["notes": notes])
            } catch {
                print(error)
            }
        }
    }
    
    func createNote() {
        let newNote = Note(context: context)
        newNote.title = String.empty
        newNote.body = String.empty
        newNote.lastModified = Date().timeIntervalSince1970
        saveContext()
    }

    @discardableResult
    func fetchNotes() -> [Note] {
        do {
            notes = try context.fetch(Note.fetchRequest())
            return notes
        } catch {
            print("Data Not Found")
            return []
        }
    }

    func updateNote(at indexPath: IndexPath,
                    with noteData: (title: String, body: String, lastModified: Double)) {
        let noteToUpdate = notes[indexPath.row]
        noteToUpdate.title = noteData.title
        noteToUpdate.body = noteData.body
        noteToUpdate.lastModified = noteData.lastModified
        
        saveContext()
    }

    func deleteNote(at indexPath: IndexPath) {
        let noteToDelete = notes[indexPath.row]
        context.delete(noteToDelete)
        saveContext()
        NotificationCenter.default.post(name: .deleteNotification, object: nil)
    }
}

extension Notification.Name {
    static let noteNotification = Notification.Name("noteNotification")
    static let deleteNotification = Notification.Name("deleteNotification")
}
