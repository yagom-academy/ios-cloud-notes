//
//  PersistanceManager.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/17.
//

import Foundation
import CoreData

class PersistanceManager {

    static var shared = PersistanceManager()

    private init() {}

    lazy var persistantContainer: NSPersistentContainer = {
        let containerObject = "CloudNotes"
        let container = NSPersistentContainer(name: containerObject)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return self.persistantContainer.viewContext
    }

    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func saveNote(note: Memo) -> Bool {
        let entityName = "Note"
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.context)

        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(note.title, forKey: "title")
            managedObject.setValue(note.body, forKey: "body")
            managedObject.setValue(note.lastModified, forKey: "lastModified")
            managedObject.setValue(UUID(), forKey: "uuid")

            do {
                try context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }

    func deleteNote(uuid: UUID) -> Bool {
        let success: Bool = true

        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@",
                                        #keyPath(Note.uuid), uuid as NSUUID)

        do {
            let notes = try context.fetch(request)
            notes.forEach { note in
                context.delete(note)
            }
            return success
        } catch {
            print(error.localizedDescription)
        }
        return !success
    }

    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
}
