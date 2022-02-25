import UIKit

protocol Synchronizable {

    var lastUpdatedDate: Date? { get set }

    func upload(memoString: String, _ completionHandler: @escaping (SynchronizationError?) -> Void)

    func download(_ completionHandler: @escaping (Result<[Content], SynchronizationError>) -> Void)

    func logIn(at controller: UIViewController)

    func convertModelToText(from model: [Content]) -> String

    func convertTextToModel(from text: String) -> [Content]?
}

extension Synchronizable {
    
    func lastUpdated() -> String {
        guard let date = self.lastUpdatedDate
        else {
            return "동기화가 아직 완료되지 않았습니다."
        }

        let formattedDate = DateFormatter.lastUploadDate.string(from: date)
        
        return "동기화가 완료 된 상태입니다.\n \(formattedDate)"
    }
}
