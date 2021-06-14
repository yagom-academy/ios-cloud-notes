//
//  NoteListViewModel.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import CoreData
import UIKit

class NoteManager {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModify", ascending: false)]
        let fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        return fetchResult
    }()
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Save Error")
        }
    }
    
    func specify(_ index: IndexPath?) -> Note {
        return fetchedResultsController.object(at: index ?? IndexPath(item: 0, section: 0))
    }
    
    func count() -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
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
    
    func update(_ text: String, _ isTitle: Bool, notedata: Note) {
        var split = text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        let title = String(split.removeFirst())
        let body = split.map { String($0) }.first
        
        notedata.title = title
        notedata.body = body
        notedata.lastModify = Date()
        
        save()
    }
}
