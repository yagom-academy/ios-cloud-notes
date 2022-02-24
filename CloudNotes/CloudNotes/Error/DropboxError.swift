import Foundation

enum DropboxError: LocalizedError {
    case failureDownload
    case failureUpload
    
    var errorDescription: String? {
        switch self {
        case .failureDownload:
            return "Download Failed".localized()
        case .failureUpload:
            return "Upload Failed".localized()
        }
    }
}
