import Foundation

enum MemoAppError: Error {
    case system
    
    var message: String {
        switch self {
        case .system:
            return "시스템 에러입니다. 개발자에게 문의하세요."
        }
    }
}
