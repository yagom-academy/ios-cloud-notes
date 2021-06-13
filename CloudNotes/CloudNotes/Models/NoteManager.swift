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
    
    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Note>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Note>
    
    // MARK: - Properties
    
    private var dataSource: DataSource?
    private let noteCoreDataStack: NoteCoreDataStack = .shared
    private var editingNote: Note?
    weak var noteDetailViewControllerDelegate: NoteDetailViewControllerDelegate?
    weak var listViewDataSource: ListViewDataSource?
    
    // MARK: - Sections for diffable data source
    
    private enum Section: CaseIterable {
        case list
    }
    
    // MARK: - Namespaces
    
    private enum TextSymbols {
        static let newLineAsElement: String.Element = "\n"
        static let newLineAsString = "\n"
        static let emptyString = ""
        static let emptySubString: Substring = ""
    }

    private enum NoteLocations {
        static let indexPathOfFirstNote = IndexPath(item: 0, section: 0)
    }
    
    // MARK: - Create, Read, Update, Delete (CRUD) Features Implemented with Core Data Stack

    func create() -> Note? {
        guard let dataSource = dataSource else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.diffableDataSourceNotImplemented(location: #function).localizedDescription)
            return nil
        }
        let snapshot = dataSource.snapshot()
        let newNote = getNewNote(title: TextSymbols.emptyString, body: TextSymbols.emptyString)
        
        if let firstItemInSnapshot = snapshot.itemIdentifiers.first {
            insert(newNote, to: dataSource, before: firstItemInSnapshot)
        } else {
            append(newNote, to: dataSource)
        }
        
        noteCoreDataStack.saveContext()
        informEditingNote(newNote, indexPath: NoteLocations.indexPathOfFirstNote)
        return newNote
    }
    
    func loadSavedNotes() {
        noteCoreDataStack.loadSavedNotes(with: self)
        configureDiffableDataSource()
        updateDiffableDataSource()
    }
    
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
        
        return editingNote
    }
    
    @discardableResult
    func delete(at indexPath: IndexPath) -> Note? {
        var currentSnapshot = dataSource?.snapshot()
        
        guard let currentNoteIdentifier = dataSource?.itemIdentifier(for: indexPath),
              let noteToDelete = noteCoreDataStack.fetchedResultsController?.object(at: indexPath) else {
            os_log(.error, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToDeleteNote(indexPath: indexPath).localizedDescription)
            return nil
        }
        
        currentSnapshot?.deleteItems([currentNoteIdentifier])
        noteCoreDataStack.persistentContainer.viewContext.delete(noteToDelete)
        noteCoreDataStack.saveContext()
        return currentNoteIdentifier
    }
    
    // MARK: - Configure and Update Diffable Data Source
    private func configureDiffableDataSource() {
        guard let noteListCollectionView = listViewDataSource?.listCollectionView else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToConfigureDiffableDataSource(location: #function).localizedDescription)
            return
        }
        
        dataSource = DataSource(collectionView: noteListCollectionView) { collectionView, indexPath, note -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewListCell.reuseIdentifier, for: indexPath) as? NoteCollectionViewListCell
            cell?.configure(with: note)
            return cell
        }
    }
    
    private func updateDiffableDataSource() {
        let sections = Section.allCases
        var updated = Snapshot()
        updated.appendSections(sections)
        updated.appendItems(noteCoreDataStack.fetchedNotes)
        dataSource?.apply(updated, animatingDifferences: false)
    }
    
    // MARK: - `Create` Supporting Methods
    
    private func getNewNote(title: String, body: String) -> Note {
        let newNote = Note(context: noteCoreDataStack.persistentContainer.viewContext)
        newNote.title = title
        newNote.body = body
        newNote.lastModified = Date()
        
        return newNote
    }
    
    private func append(_ newNote: Note, to dataSource: DataSource) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([newNote])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func insert(_ newNote: Note, to dataSource: DataSource, before firstItemInSnapshot: Note) {
        var snapshot = dataSource.snapshot()
        snapshot.insertItems([newNote], beforeItem: firstItemInSnapshot)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - `Read` Supporting Methods
    
    func getNote(at indexPath: IndexPath) -> Note? {
        guard let editingNote = dataSource?.itemIdentifier(for: indexPath) else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.failedToGetNote(indexPath: indexPath, location: #function).localizedDescription)
            return nil
        }
        informEditingNote(editingNote, indexPath: indexPath)
        return editingNote
    }
    
    // MARK: - `Update` Supporting Methods
    
    /// Call this method when the target note for edit changes to inform the note and location to be changed to related objects such as view controllers.
    private func informEditingNote(_ editingNote: Note, indexPath: IndexPath) {
        self.editingNote = editingNote
        noteDetailViewControllerDelegate?.setIndexPathForSelectedNote(indexPath)
    }
}

// MARK: - Note List View Controller Delegate

extension NoteManager: NoteManagerDelegate {
    func changeNote(with newText: String) {
        guard let newNote = update(with: newText),
              var snapshot = dataSource?.snapshot() else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.diffableDataSourceNotImplemented(location: #function).localizedDescription)
            return
        }
        snapshot.deleteItems([newNote])
        
        guard let firstNoteInSnapshot = snapshot.itemIdentifiers.first else {
            os_log(.fault, log: .data, OSLog.objectCFormatSpecifier, DataError.snapshotIsEmpty(location: #function).localizedDescription)
            return
        }
        snapshot.insertItems([newNote], beforeItem: firstNoteInSnapshot)
        noteCoreDataStack.saveContext()
    }
}

// MARK: - NSFetchedResultsController Delegate

extension NoteManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateDiffableDataSource()
        listViewDataSource?.listCollectionView?.selectItem(at: NoteLocations.indexPathOfFirstNote, animated: false, scrollPosition: .top)
    }
}
