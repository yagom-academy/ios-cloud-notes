import UIKit

class NoteModelManager {
    
    private var noteData: [Note] = []
    var noteDataCount: Int {
        return noteData.count
    }
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy MM dd")
        formatter.locale = NSLocale.current
        return formatter
    }()
    
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
}
