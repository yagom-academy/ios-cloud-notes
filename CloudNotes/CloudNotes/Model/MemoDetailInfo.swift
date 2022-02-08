import Foundation

struct MemoDetailInfo {
    let title: String
    let body: String
    
    var text: String {
        return "\(title)\n\n\(body)"
    }
}
