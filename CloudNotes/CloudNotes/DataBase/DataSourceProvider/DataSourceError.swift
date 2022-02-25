import Foundation

enum DataSourceError: Error {
    
    case decodingFailure
    case jsonNotFound
    case coreDataSaveFailure
}
