import Foundation

protocol MemoType {
    var title: String? { get set }
    var body: String? { get set }
    var lastModified: Date? { get set }
    var identifier: UUID? { get set }
}

extension MemoType {
    func createAttributes(body: String) -> [String: Any] {
        var attribute: [String: Any] = [:]
        let title = body.components(separatedBy: "\n")[0]
        let long = body.components(separatedBy: "\n")[1...].joined()
        attribute.updateValue(title, forKey: "title")
        attribute.updateValue(long, forKey: "body")
        attribute.updateValue(Date(), forKey: "lastModified")
        return attribute
    }
}
