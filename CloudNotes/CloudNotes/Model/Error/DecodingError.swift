//
//  DecodingError.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/06.
//

import Foundation

enum DecodingError: Error, CustomStringConvertible {
  case PathNotFound, DataConversionFailed
}

extension DecodingError {
  var description: String {
    switch self {
    case .PathNotFound:
      return "디코딩 경로를 찾을 수 없습니다."
    case .DataConversionFailed:
      return "디코딩 데이터 변환에 실패하였습니다."
    }
  }
}
