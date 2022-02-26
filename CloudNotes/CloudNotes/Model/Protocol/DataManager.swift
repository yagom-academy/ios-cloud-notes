import Foundation

protocol DataManager {
    
    func create(attributes: [String: Any])
    
    func read(index: IndexPath) -> MemoType?
    
    func update(target: MemoType, attributes: [String: Any])
    
    func delete(target: MemoType)
    
    func countAllData() -> Int
}
