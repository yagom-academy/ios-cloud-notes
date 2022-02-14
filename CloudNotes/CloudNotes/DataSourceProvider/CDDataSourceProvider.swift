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
            guard let title = note.title, let body = note.body else {
                return
            }

            let newNote = Content(
                title: title,
                body: body,
                lastModifiedDate: note.modifiedDate)

            self.noteList.append(newNote)
        }
    }

    func saveContext() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror)")
            }
        }
    }

}
