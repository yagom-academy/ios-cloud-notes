import Foundation

enum DecodingUtility {
    
    static let decoder = JSONDecoder()

    static func decode<T: Decodable>(data: Data) throws -> T {
        guard let decodedData = try? decoder.decode(T.self, from: data)
        else {
            throw DataSourceError.decodingFailure
        }

        return decodedData
    }
}
