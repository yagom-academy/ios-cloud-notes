import UIKit
import CoreData

class NoteModelManager: NSObject, NoteModel {
    
    var persistentDataManager: PersistentDataManager
    var noteData: [Note] {
        return controller.fetchedObjects?.compactMap { note in
            guard let identifier = note.identifier,
                  let title = note.title,
                  let body = note.body,
                  let lastModified = note.lastModified else {
                      return nil
                  }
            return Note(identifier: identifier, title: title, body: body, lastModified: lastModified)
        } ?? []
    }
    var countOfNoteData: Int {
        return noteData.count
    }
    
    var updateHandler: (() -> Void)?
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy MM dd")
        formatter.locale = NSLocale.current
        return formatter
    }()
    
    private lazy var controller = NSFetchedResultsController(
        fetchRequest: CDNote.fetchSortedNoteRequest(),
        managedObjectContext: persistentDataManager.context,
        sectionNameKeyPath: nil,
        cacheName: nil)

    init(persistentDataManager: PersistentDataManager) {
        self.persistentDataManager = persistentDataManager
    }
    
    func fetchData() {
        controller.delegate = self
        try? controller.performFetch()
    }
    
    func fetchTitle(at index: Int) -> String {
        let noteData = self.noteData[index]
        return noteData.title
    }
    
    func fetchDate(at index: Int) -> String {
        let noteData = self.noteData[index]
        let formattedDate = formatter.string(from: noteData.lastModified).replacingOccurrences(of: "/", with: ". ")
        return formattedDate
    }

    func fetchBody(at index: Int) -> String {
        let noteData = self.noteData[index]
        return noteData.body
    }
    
    func deleteNote(at index: Int) {
        guard let identifier = noteData[index].identifier else {
            return
        }
        let fetchRequest = CDNote.fetchNoteRequest(with: identifier)
        
        try? persistentDataManager.delete(request: fetchRequest)
    }
    
    func createNote(_ note: Note) {
        try? persistentDataManager.create(entity: "CDNote") { managedObject in
            [
                "identifier": UUID(),
                "title": note.title,
                "body": note.body,
                "lastModified": note.lastModified
            ].forEach { key, value in
                managedObject.setValue(value, forKey: key)
            }
        }
    }
    
    func updateNote(_ note: Note) {
        guard let identifier = note.identifier else {
            return
        }
        let fetchRequest = CDNote.fetchNoteRequest(with: identifier)
        
        try? persistentDataManager.update(request: fetchRequest) { filteredResult in
            [
                "title": note.title,
                "body": note.body,
                "lastModified": Date()
            ].forEach { key, value in
                filteredResult.setValue(value, forKey: key)
            }
        }
    }
    
}

extension NoteModelManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateHandler?()
    }
    
}
