import Foundation
import CoreData

final class NoteModel {
    
    private let persistentDataManager: PersistentDataManager
    
    private(set) lazy var controller = NSFetchedResultsController(
        fetchRequest: CDNote.fetchSortedNoteRequest(),
        managedObjectContext: persistentDataManager.context,
        sectionNameKeyPath: nil,
        cacheName: nil)
    
    var fetchedObjects: [Note] {
        return controller.fetchedObjects?.compactMap { note in
            return Note(cdNote: note)
        } ?? []
    }
    
    init(persistentDataManager: PersistentDataManager) {
        self.persistentDataManager = persistentDataManager
        try? controller.performFetch()
    }
    
    func fetchNote(identifier: UUID) -> Note? {
        let request = CDNote.fetchNoteRequest(with: identifier)
        let result = try? persistentDataManager.fetch(request: request)
        
        guard let cdNote = result?.first else {
            return nil
        }
        
        return Note(cdNote: cdNote)
    }
    
    func createNote() {
        try? persistentDataManager.create(entity: "CDNote") { managedObject in
            [
                "identifier": UUID(),
                "title": "",
                "body": "",
                "lastModified": Date()
            ].forEach { key, value in
                managedObject.setValue(value, forKey: key)
            }
        }
    }
    
    func deleteNote(identifier: UUID) {
        let fetchRequest = CDNote.fetchNoteRequest(with: identifier)
        try? persistentDataManager.delete(request: fetchRequest)
    }
    
    func updateNote(_ note: Note) {
        let fetchRequest = CDNote.fetchNoteRequest(with: note.identifier)
        
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
