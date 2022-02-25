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
        let sort = NSSortDescriptor(key: "modifiedDate", ascending: false)
        request.sortDescriptors = [sort]
        let notes = try persistentManager.fetch(request: request)

        notes.forEach { note in
            guard let title = note.title, let body = note.body, let id = note.identification
            else {
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

    func createNote(_ note: Content) throws {
        let values: [String: Any] = [
            "title": note.title,
            "body": note.body,
            "modifiedDate": note.lastModifiedDate,
            "identification": note.identification
        ]

        try persistentManager.create(entityName: String(describing: Note.self), values: values)
        try fetch()
    }

    func updateNote(_ updatedNote: Content) throws {
        let request = Note.fetchRequest()
        let predicate = NSPredicate(
            format: "identification == %@",
            updatedNote.identification.uuidString
        )
        let notes = try persistentManager.fetch(request: request, predicate: predicate)

        guard let note = notes.first
        else {
            return
        }

        let values: [String: Any] = [
            "title": updatedNote.title,
            "body": updatedNote.body,
            "modifiedDate": updatedNote.lastModifiedDate
        ]

        try persistentManager.update(object: note, values: values)
        try fetch()
    }

    func deleteNote(_ noteToDelete: Content) throws {
        let request = Note.fetchRequest()
        let uuid = noteToDelete.identification.uuidString
        let predicate = NSPredicate(format: "identification == %@", uuid)
        let notes = try persistentManager.fetch(request: request, predicate: predicate)

        guard let note = notes.first
        else {
            return
        }

        try persistentManager.delete(object: note)
        try fetch()
    }

    func deleteAllNote() throws {
        let request = Note.fetchRequest()
        
        persistentManager.deleteAll(request: request)

        try fetch()
    }
}
