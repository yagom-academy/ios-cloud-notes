import Foundation

class AssetDataManager: DataManager {
    
    private var list: [MemoType] {
        let list2 = JSONParser.decodeData(of: "sample", how: [Memo].self)
        var returnList: [MemoType] = []
        list2?.forEach { data in
            if let dataEach = data as? MemoType {
                returnList.append(dataEach)
            }
        }
        return returnList
    }
    
    func create(attributes: [String: Any]) {
        return
    }
    
    func read(index: IndexPath) -> MemoType? {
        list[index.row]
    }
    
    func update(target: MemoType, attributes: [String: Any]) {
        return
    }
    
    func delete(target: MemoType) {
        return
    }
    
    func countAllData() -> Int {
        list.count
    }
}
