import Foundation
import CoreData

class PersistentManager {
    static let shared = PersistentManager()
    private init() {}

    private(set) var notes = [Note]()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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

extension PersistentManager {
    func insertNote(_ note: Note) {
        notes.insert(note, at: 0)
    }
    
    func setUpNotes() {
        guard let newData = fetch() else {
            return
        }
        self.notes = newData
    }
    
    func removeNote(at index: Int) -> Note {
        return notes.remove(at: index)
    }
    
    func deleteAll(_ item: [Note]) {
        item.forEach { item in
            delete(item)
        }
    }
    
    func moveNotes(from oldIndex: Int, to newIndex: Int) {
        notes.move(from: oldIndex, to: newIndex)
    }
}

// MARK: - CRUD
extension PersistentManager {
    @discardableResult
    func insert(entityName: String = "Note", items: [String: Any]) -> Note? {
        let context = persistentContainer.viewContext
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return update(managedObject, items: items)
    }
    
    @discardableResult
    func fetch(
        entityName: String = "Note",
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(key: "lastModified", ascending: false)]
    ) -> [Note]? {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = sortDescriptors
        guard let newData = try? context.fetch(request) as? [Note] else {
            return nil
        }
        return newData
    }
    
    @discardableResult
    func update(_ managedObject: NSManagedObject, items: [String: Any]) -> Note? {
        let keys = managedObject.entity.attributesByName.keys
        for key in keys {
            if let value = items[key] {
                managedObject.setValue(value, forKey: key)
            }
        }
        saveContext()
        fetch()
        return managedObject as? Note
    }
    
    func delete(_ item: Note) {
        let context = persistentContainer.viewContext
        let note = item as NSManagedObject
        context.delete(note)
        saveContext()
    }

    func updateNote(
        entityName: String = "Note",
        id: UUID?,
        title: String?,
        body: String?,
        lastModified: TimeInterval
    ) {
        guard let id = id else {
            return
        }
        let predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let note = fetch(entityName: entityName, predicate: predicate)?.first else {
            return
        }
        note.title = title
        note.body = body
        note.lastModified = lastModified
        saveContext()
    }
}
