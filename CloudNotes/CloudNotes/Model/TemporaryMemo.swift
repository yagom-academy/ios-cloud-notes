import Foundation

struct TemporaryMemo: MemoEntity {
    let title: String?
    let body: String?
    let lastModifiedDate: Double
    let memoId: UUID?
}
