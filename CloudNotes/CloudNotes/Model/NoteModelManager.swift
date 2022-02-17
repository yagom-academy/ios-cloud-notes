import UIKit
import CoreData

class NoteModelManager: NoteModel {
    
    var persistentDataManager: PersistentDataManager
    var noteData: [Note] = [] {
        didSet {
            updateHandler?()
        }
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
    
    init(persistentDataManager: PersistentDataManager) {
        self.persistentDataManager = persistentDataManager
    }
    
    func fetchData() {
        let decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            return decoder
        }()
        let jsonAsset = NSDataAsset(name: "sample")
        guard let jsonData = jsonAsset?.data else {
            return
        }
        if let result = try? decoder.decode([Note].self, from: jsonData) {
            noteData = result
            
            noteData.indices.forEach { index in
                noteData[index].identifier = UUID()
            }
        }
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
        noteData.remove(at: index)
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
        let identifier = UUID().uuidString
        let request = NSFetchRequest<CDNote>(entityName: "CDNote")
        request.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        try? persistentDataManager.update(request: request) { filteredResult in
            [
                "title": note.title,
                "body": note.body,
                "lastModified": note.lastModified
            ].forEach { key, value in
                filteredResult.setValue(value, forKey: key)
            }
        }
    }
    
}
