//
//  SetMemoInfoListError.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/06.
//

import Foundation

enum SetMemoInfoListError: Error, CustomStringConvertible {
  case FailedToAccessAppDelegate
  case FailedToGetNSManagedObjectContext
}

extension SetMemoInfoListError {
  var description: String {
    switch self {
    case .FailedToAccessAppDelegate:
      return "AppDelegate 접근에 실패하였습니다."
    case .FailedToGetNSManagedObjectContext:
      return "NSManagedObjectContext를 가져오는데 실패하였습니다."
    }
  }
}
