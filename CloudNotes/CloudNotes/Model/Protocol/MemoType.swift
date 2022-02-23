import Foundation

protocol MemoType {
    var title: String? { get set }
    var body: String? { get set }
    var lastModified: Date? { get set }
    var identifier: UUID? { get set }
}
