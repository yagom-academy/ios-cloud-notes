import Foundation

protocol DataProvider {
    func create(target: MemoType, attributes: [String: Any])
    func update(target: T, attributes: [String: Any])
    func read(index: IndexPath) -> MemoType
    func delete(target: MemoType)
}
