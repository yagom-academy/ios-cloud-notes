import Foundation

enum MemoAppSystemError: Error {
    case fetchFailed
    case saveFailed
    case deleteFailed
    case updateFailed
    case unkowned
    
    var message: String {
        switch self {
        case .fetchFailed:
            return "데이터를 가져오는데에 실패했습니다."
        case .saveFailed:
            return "데이터를 저장하는데에 실패했습니다."
        case .deleteFailed:
            return "데이터를 삭제하는데에 실패했습니다."
        case .updateFailed:
            return "데이터를 업데이트하는데에 실패했습니다."
        case .unkowned:
            return "시스템 에러입니다. 개발자에게 문의하세요."
        }
    }
}
