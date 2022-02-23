import Foundation
import CoreData

final class NoteViewModel: NSObject {
    
    private let model: NoteModel
    var updateUIHandler: (() -> Void)?
    var updateUIByDataHandler: ((NSFetchedResultsChangeType) -> Void)?
    
    init(model: NoteModel) {
        self.model = model
    }
    
    func viewDidLoad() {
        model.controller.delegate = self
    }
    
    var noteData: [Note] {
        return model.fetchedObjects
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy MM dd")
        formatter.locale = NSLocale.current
        return formatter
    }()
    
    func fetchDate(note: Note) -> String {
        let formattedDate = formatter.string(from: note.lastModified).replacingOccurrences(of: "/", with: ". ")
        return formattedDate
    }
    
    func fetchTitle(identifier: UUID) -> String {
        let note = model.fetchNote(identifier: identifier)
        return note?.title ?? ""
    }
    
    func fetchBody(identifier: UUID) -> String {
        let note = model.fetchNote(identifier: identifier)
        return note?.body ?? ""
    }
    
    func createNote() {
        model.createNote()
    }
    
    func deleteNote(identifier: UUID) {
        model.deleteNote(identifier: identifier)
    }
    
    func updateNote(identifier: UUID, title: String, body: String) {
        let note = Note(identifier: identifier, title: title, body: body, lastModified: Date())
        model.updateNote(note)
    }
    
}

extension NoteViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        updateUIHandler?()
        updateUIByDataHandler?(type)
    }
    
}
