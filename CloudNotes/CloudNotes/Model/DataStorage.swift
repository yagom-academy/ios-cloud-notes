import Foundation
import UIKit

class DataStorage: DataProvidable {
    var assetData: [Sample]? {
        return try? JSONParser.decodeData(of: "sample", how: [Sample].self)
    }
}
