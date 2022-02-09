import UIKit

struct JSONParser {
    private let decoder = JSONDecoder()
    
    func decode<T: Decodable>(fileName: String, decodingType: T.Type) -> T? {
        guard let asset = NSDataAsset(name: fileName) else {
            return nil
        }
        let decodedData = try? decoder.decode(T.self, from: asset.data)
        return decodedData
    }
}
