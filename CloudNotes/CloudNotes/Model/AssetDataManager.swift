import Foundation

class AssetDataManager: DataProvider {
    private var list: [MemoType] {
        let list2 = JSONParser.decodeData(of: "sample", how: [SampleData].self)
        var returnList: [MemoType]
        list2?.forEach { data in
            if let dataEach = data as? MemoType {
                returnList.append(dataEach)
            }
        }
        return returnList
    }
    
    func create(target: MemoType, attributes: [String : Any]) {
        return
    }
    
    func update() {
        return
    }
    
    func read(index: IndexPath) -> MemoType {
        list[index.row]
    }
    
    func delete(target: MemoType) {
        return
    }
    
}
