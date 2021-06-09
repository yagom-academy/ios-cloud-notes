//
//  CloudNoteError.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/04.
//

import Foundation

enum CloudNoteError: Error {
    
    case decode
    case invalid
    
    var localizedDescription: String {
        switch self {
        case .decode:
            return "디코드 에러"
        case .invalid:
            return "알 수 없는 에러"
        }
    }
    
}
