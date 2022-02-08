//
//  DecodingError.swift
//  CloudNotes
//
//  Created by 고은 on 2022/02/08.
//

import Foundation

enum DataSourceError: Error {
    case decodingFailure
    case jsonNotFound
}
