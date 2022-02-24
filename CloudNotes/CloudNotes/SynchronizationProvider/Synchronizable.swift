import UIKit

protocol Synchronizable {
    var lastUpdatedDate: Date? { get set }

    func upload(_ completionHandler: @escaping (SynchronizationError?) -> Void)

    func download(_ completionHandler: @escaping (SynchronizationError?) -> Void)

    func logIn(at controller: UIViewController)
}

extension Synchronizable {
    func lastUpdated() -> String {
        guard let date = self.lastUpdatedDate else {
            return "동기화가 아직 완료되지 않았습니다."
        }
        let formattedDate = DateFormatter.lastUploadDate.string(from: date)
        return "동기화가 완료 된 상태입니다.\n \(formattedDate)"
    }
}
