import Foundation

protocol MemoEntity {
    var title: String? { get }
    var body: String? { get }
    var lastModifiedDate: Double { get }
    var memoId: UUID? { get }
}
