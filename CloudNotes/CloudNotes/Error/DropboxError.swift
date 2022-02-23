import Foundation

enum DropboxError: LocalizedError {
    case failureDownload
    case failureUpload
    
    var errorDescription: String? {
        switch self {
        case .failureDownload:
            return "다운로드를 실패하였습니다."
        case .failureUpload:
            return "업로드를 실패하였습니다."
        }
    }
}
