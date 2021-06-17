//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import CoreData
import UIKit

final class NoteManager: NSObject {
    
    static let shared = NoteManager()
    var coreDataDelegate: CoreDataDelegate?
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModify", ascending: false)]
        let fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                     managedObjectContext: context,
                                                     sectionNameKeyPath: nil,
                                                     cacheName: nil)
        fetchResult.delegate = self
        return fetchResult
    }()
    
    private override init() { }
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(CoreDataError.save(error).errorDescription ?? "")
            }
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Save Error")
        }
    }
    
    func specify(_ index: IndexPath?) -> Note {
        guard let index = index else { return Note() }
        if (fetchedResultsController.fetchedObjects?.count ?? 0) - 1 < index.row {
            print(CoreDataError.indexPath.errorDescription ?? "")
            return Note()
        }
        return fetchedResultsController.object(at: index)
    }
    
    func count() -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func create() -> Note {
        let newNote = Note(context: context)
        newNote.title = ""
        newNote.body = ""
        newNote.lastModify = Date()
        
        return newNote
    }
    
    func insert(_ data: Note) {
        context.insert(data)
        save()
    }
    
    func fetch() -> Result<Bool, Error> {
        do {
            try fetchedResultsController.performFetch()
            return .success(true)
        } catch {
            return .failure(CoreDataError.fetch(error))
        }
    }
    
    func delete(_ date: Note) {
        self.context.delete(date)
        
        do {
            save()
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Delete Data Error :\(error.localizedDescription)")
        }
    }
    
    func update(_ text: String, notedata: Note) {
        var split = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        let title = String(split.removeFirst())
        let body = split.map { String($0) }.first
        
        notedata.title = title
        notedata.body = body
        notedata.lastModify = Date()
        
        save()
    }
}

extension NoteManager: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            coreDataDelegate?.insert(current: indexPath, new: newIndexPath)
        case .delete:
            coreDataDelegate?.delete(current: indexPath, new: newIndexPath)
        case .move:
            coreDataDelegate?.move(current: indexPath, new: newIndexPath)
        case .update:
            coreDataDelegate?.update(current: indexPath, new: newIndexPath)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }
}
