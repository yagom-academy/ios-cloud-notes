import Foundation
import UIKit

enum JSONParser {
    
    static func decodeData<T: Decodable>(of dataName: String, how: T.Type) -> T? {
        guard let data = NSDataAsset(name: dataName)
        else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(how, from: data.data)
        else {
            return nil
        }
        return decodedData
    }
}
