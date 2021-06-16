//
//  MemoInfo+CoreDataClass.swift
//  CloudNotes
//
//  Created by 강경 on 2021/06/08.
//
//

import Foundation
import CoreData

@objc(MemoInfo)
public class MemoInfo: NSManagedObject {
  static let defaultTitle = "새로운 메모"
  static let defaultBody = "빈 메모입니다. 내용을 작성해주세요."
}
