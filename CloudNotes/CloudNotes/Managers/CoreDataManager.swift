//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by Kyungmin Lee on 2021/03/01.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var notes = [Note]()
    
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key: "lastModifiedDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            notes = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func createNote(title: String?, body: String?) {
        let note = Note(context: mainContext)
        note.title = title
        note.body = body
        note.lastModifiedDate = Date()
        
        notes.append(note)
        saveContext()
    }
    
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

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
