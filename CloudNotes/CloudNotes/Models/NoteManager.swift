//
//  NoteManager.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/13.
//

import UIKit
import os
import CoreData

final class NoteManager: NSObject {
    
    // MARK: - Properties
    
    private let noteCoreDataStack: CoreDataStack
    private var editingNote: Note?
    var fetchedNotes: [Note] {
        return noteCoreDataStack.fetchedResultsController?.fetchedObjects ?? []
    }
    
    init(coreDataStack: CoreDataStack = NoteCoreDataStack.shared) {
        noteCoreDataStack = coreDataStack
        super.init()
    }
    
    // MARK: - Namespaces
    
    private enum Texts {
        static let newLineAsElement: String.Element = "\n"
        static let newLine = "\n"
        static let empty = ""
    }
    
    // MARK: - Create, Read, Update, Delete (CRUD) Features Implemented with Core Data Stack

    func createNewNote(title: String, body: String, date: Date) -> Note {
        let newNote = Note(context: noteCoreDataStack.persistentContainer.viewContext)
        newNote.title = title
        newNote.body = body
        newNote.lastModified = date
        
        saveContext()
        return newNote
    }
    
    func loadSavedNotes() {
        noteCoreDataStack.loadSavedNotes(with: self)
    }
    
    @discardableResult
    func updateNote(with newText: String) -> Note? {
        var text = newText.split(separator: Texts.newLineAsElement, maxSplits: 1, omittingEmptySubsequences: false)
        guard let editingNote = editingNote else {
            Loggers.data.log(level: .error, "\(DataError.editingNoteNotSet(location: #function))")
            return nil
        }
        let newTitle = [text.removeFirst()].joined()
        let newBody = text.joined()
        let currentDate = Date()
        
        editingNote.title = newTitle
        editingNote.body = newBody == Texts.newLine ? Texts.empty : newBody
        editingNote.lastModified = currentDate
        
        saveContext()
        return editingNote
    }
    
    @discardableResult
    func deleteNote(_ note: Note) -> Note {
        noteCoreDataStack.persistentContainer.viewContext.delete(note)
        saveContext()
        return note
    }
    
    func saveContext() {
        noteCoreDataStack.saveContext()
    }
    
    func setEditingNote(_ note: Note) {
        editingNote = note
    }
}

// MARK: - NSFetchedResultsController Delegate

extension NoteManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // intentionally remained blank due to notify changes have been made to fetched results controller so that reflect to its own fetched objects.
    }
}
