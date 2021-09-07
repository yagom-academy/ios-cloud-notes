//
//  DataManager.swift
//  CloudNotes
//
//  Created by JINHONG AN on 2021/09/04.
//

import Foundation

enum DataManagingError: Error, LocalizedError {
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}

struct DataManager {
    private let dataImportModule: DataImportable
    
    init(dataImportModule: DataImportable) {
        self.dataImportModule = dataImportModule
    }
    
    func obtainData<T: Decodable>(completionHandler: @escaping (Result<T, Error>) -> Void) {
        dataImportModule.importData { (data: T?, error: Error?) in
            if let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data))
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(.failure(DataManagingError.unknown))
                }
            }
        }
    }
}
