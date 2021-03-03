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
    static let noteDataDidChange = Notification.Name(rawValue: "noteDataDidChange")
    
    private init() {
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var noteList = [Note]()
    var noteCount: Int {
        return noteList.count
    }
    
    func fetchNoteList() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "lastModifiedDate", ascending: false)
        request.sortDescriptors = [sortByDate]
        
        do {
            noteList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func createNote(title: String?, body: String?) -> Note {
        let note = Note(context: mainContext)
        note.title = title
        note.body = body
        note.lastModifiedDate = Date()
        
        noteList.insert(note, at: 0)
        saveContext()
        NotificationCenter.default.post(name: CoreDataManager.noteDataDidChange, object: nil)
        
        return note
    }
    
    func note(index: Int) -> Note? {
        guard noteList.count > index, index >= 0 else {
            return nil
        }
    
        return noteList[index]
    }
    
    func updateNote(note: Note, title: String?, body: String?) {
        note.title = title
        note.body = body
        note.lastModifiedDate = Date()
        
        saveContext()
        fetchNoteList()
        NotificationCenter.default.post(name: CoreDataManager.noteDataDidChange, object: nil)
    }
    
    func deleteNote(index: Int) {
        guard noteList.count > index, index >= 0 else {
            return
        }
        
        let note = noteList[index]
        mainContext.delete(note)
        saveContext()
        fetchNoteList()
        NotificationCenter.default.post(name: CoreDataManager.noteDataDidChange, object: nil)
    }
    
    func deleteNote(note: Note) {
        if let index = noteList.firstIndex(of: note) {
            deleteNote(index: index)
        }
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
