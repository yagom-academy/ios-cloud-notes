//
//  NoteManager.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/13.
//

import UIKit
import OSLog
import CoreData

final class NoteManager: NSObject {
    
    // MARK: - Properties
    
    private let noteCoreDataStack: NoteCoreDataStack = .shared
    private var editingNote: Note?
    weak var noteDetailViewControllerDelegate: NoteDetailViewControllerDelegate?
    var fetchedNotes: [Note] {
        return noteCoreDataStack.fetchedResultsController?.fetchedObjects ?? []
    }
    
    // MARK: - Namespaces
    
    private enum TextSymbols {
        static let newLineAsElement: String.Element = "\n"
        static let newLineAsString = "\n"
        static let emptyString = ""
        static let emptySubString: Substring = ""
    }
    
    // MARK: - Create, Read, Update, Delete (CRUD) Features Implemented with Core Data Stack

    func create(title: String, body: String, date: Date) -> Note {
        let newNote = Note(context: noteCoreDataStack.persistentContainer.viewContext)
        newNote.title = title
        newNote.body = body
        newNote.lastModified = Date()
        
        informEditingNote(newNote, indexPath: NoteListViewController.NoteLocations.indexPathOfFirstNote)
        noteCoreDataStack.saveContext()
        return newNote
    }
    
    func loadSavedNotes() {
        noteCoreDataStack.loadSavedNotes(with: self)
    }
    
    @discardableResult
    func update(with newText: String) -> Note? {
        var text = newText.split(separator: TextSymbols.newLineAsElement, omittingEmptySubsequences: false)
        var textHasTitleAtLeast: Bool {
            return text.count >= 1
        }
        var newBodyHasText: Bool {
            return newBody != TextSymbols.newLineAsString
        }
        guard let editingNote = editingNote else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.editingNoteNotSet(location: #function).localizedDescription)
            return nil
        }
        var newTitle = String(text.first ?? TextSymbols.emptySubString)
        var newBody = TextSymbols.emptyString
        let currentDate = Date()
        
        editingNote.title = newTitle
        editingNote.body = newBody
        editingNote.lastModified = currentDate
        
        if textHasTitleAtLeast {
            newTitle = String(text.removeFirst())
            editingNote.title = newTitle
            newBody = text.joined(separator: TextSymbols.newLineAsString)
        }
        
        if newBodyHasText {
            editingNote.body = newBody
        }
        
        noteCoreDataStack.saveContext()
        return editingNote
    }
    
    @discardableResult
    func delete(_ note: Note) -> Note {
        noteCoreDataStack.persistentContainer.viewContext.delete(note)
        noteCoreDataStack.saveContext()
        return note
    }
    
    // MARK: - `Read` Supporting Methods
    
    func getNote(at indexPath: IndexPath) -> Note? {
        guard let fetchedObjects = noteCoreDataStack.fetchedResultsController?.fetchedObjects else {
            return nil
        }
        
        if fetchedObjects.isEmpty {
            informEditingNote(nil, indexPath: nil)
            return nil
        }
        
        guard let editingNote = noteCoreDataStack.fetchedResultsController?.object(at: indexPath) else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToGetNote(indexPath: indexPath, location: #function).localizedDescription)
            return nil
        }
        informEditingNote(editingNote, indexPath: indexPath)
        return editingNote
    }
    
    // MARK: - `Update` Supporting Methods
    
    /// Call this method when the target note for edit changes to inform the note and location to be changed to related objects such as view controllers.
    private func informEditingNote(_ editingNote: Note?, indexPath: IndexPath?) {
        self.editingNote = editingNote
        noteDetailViewControllerDelegate?.setIndexPathForSelectedNote(indexPath)
    }
}

// MARK: - NSFetchedResultsController Delegate

extension NoteManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // intentionally remained blank due to notify changes have been made to fetched results controller so that reflect to its own fetched objects.
    }
}
