import UIKit

class MemoDataManager {
    static let shared = MemoDataManager()
    var memos = [Memo]()
    
    private init() {
        loadJSON()
    }
    
    private func loadJSON() {
        guard let data = NSDataAsset(name: "sample")?.data else {
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .secondsSince1970
            let memo = try decoder.decode([Memo].self, from: data)
            memos.append(contentsOf: memo)
        } catch let error {
            print(error)
        }
    }
}
