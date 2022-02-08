import UIKit

class NoteModelManager {
    
    private var noteData: [Note] = []
    var noteDataCount: Int {
        return noteData.count
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
        }
    }
    
    func fetchDetailData(at index: Int) -> Note {
        return noteData[index]
    }
    
}
