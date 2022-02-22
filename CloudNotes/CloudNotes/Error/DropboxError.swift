import Foundation

enum DropboxError: LocalizedError {
    case failureDownload
    
    var errorDescription: String? {
        switch self {
        case .failureDownload:
            return "다운로드를 실패하였습니다."
        }
    }
}
