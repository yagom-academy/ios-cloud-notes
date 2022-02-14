import UIKit

class DataStorage {
    var assetData: [Sample] {
        return JSONParser.decodeData(of: "sample", how: [Sample].self) ?? [Sample(title: "", body: "", lastModified: .zero)]
    }
}
