import Foundation

enum MemoFormat {
    case defaults
    
    var attributes: [String: Any] {
        ["title": "새로운 메모", "body": "", "lastModified": Date(), "identifier": UUID()] as [String: Any]
    }
}
