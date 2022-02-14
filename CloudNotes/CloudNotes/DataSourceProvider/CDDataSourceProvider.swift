import Foundation
import CoreData

class CDDataSourceProvider: NoteDataSource {
    var noteList: [Content]

    init() {
        self.noteList = []
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError()
            }
        }

        return container
    }()

    var context: NSManagedObjectContext {
        return self.persistentContainer.newBackgroundContext()
    }

    func fetch() throws {
        let request = Note.fetchRequest()
        self.noteList = []
        let notes = try self.context.fetch(request)
        notes.forEach { note in
            guard let title = note.title, let body = note.body, let id = note.identification else {
                return
            }

            let newNote = Content(
                title: title,
                body: body,
                lastModifiedDate: note.modifiedDate,
                identification: id)

            self.noteList.append(newNote)
        }
    }

    func createNote(_ note: Content) {
        let context = self.context
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)

        if let entity = entity {
            let content = NSManagedObject(entity: entity, insertInto: context)
            content.setValue(note.title, forKey: "title")
            content.setValue(note.body, forKey: "body")
            content.setValue(note.lastModifiedDate, forKey: "modifiedDate")
            content.setValue(note.identification, forKey: "identification")
        }

        self.saveContext(context)
    }

    func updateNote(updatedNote: Content) {
        let context = self.context
        let request = Note.fetchRequest()
        let predicate = NSPredicate(
            format: "identification == %@",
            updatedNote.identification.uuidString
        )
        request.predicate = predicate

        do {
            let notes = try context.fetch(request)
            guard let note = notes.first else {
                return
            }

            note.setValue(note.title, forKey: "title")
            note.setValue(note.body, forKey: "body")
            note.setValue(note.modifiedDate, forKey: "modifiedDate")
        } catch {
            print(error)
        }

        self.saveContext(context)
    }

    func deleteNote(uuid: UUID) {
        let context = self.context
        let request = Note.fetchRequest()
        let predicate = NSPredicate(format: "identification == %@", uuid.uuidString)
        request.predicate = predicate

        do {
            let notes = try context.fetch(request)
            guard let note = notes.first else {
                return
            }

            context.delete(note)
        } catch {
            print(error)
        }

        self.saveContext(context)
    }

    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror)")
            }
        }
    }
}
