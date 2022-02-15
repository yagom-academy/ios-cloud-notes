import Foundation
import CoreData

class CDDataSourceProvider: NoteDataSource {
    var noteList: [Content]
    private let persistentManager = PersistentManager.shared

    init() {
        self.noteList = []
    }

    func fetch() throws {
        let request = Note.fetchRequest()
        self.noteList = []
        let notes = try persistentManager.fetch(request: request)
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
        let values: [String : Any] = [
            "title": note.title,
            "body": note.body,
            "modifiedDate": note.lastModifiedDate,
            "identification": note.identification
        ]

        persistentManager.create(entityName: String(describing: Note.self), values: values)
    }

    func updateNote(_ updatedNote: Content) throws {
        let request = Note.fetchRequest()
        let predicate = NSPredicate(
            format: "identification == %@",
            updatedNote.identification.uuidString
        )
        let notes = try persistentManager.fetch(request: request, predicate: predicate)
        guard let note = notes.first else {
            return
        }

        let values: [String : Any] = [
            "title": updatedNote.title,
            "body": updatedNote.body,
            "modifiedDate": updatedNote.lastModifiedDate
        ]

        persistentManager.update(object: note, values: values)
    }

    func deleteNote(_ noteToDelete: Note) throws {
        let request = Note.fetchRequest()
        guard let uuid = noteToDelete.identification?.uuidString else {
            return
        }

        let predicate = NSPredicate(format: "identification == %@", uuid)
        let notes = try persistentManager.fetch(request: request, predicate: predicate)
        guard let note = notes.first else {
            return
        }

        persistentManager.delete(object: note)
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
