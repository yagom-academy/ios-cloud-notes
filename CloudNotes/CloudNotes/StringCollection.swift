//
//  LiteralManager.swift
//  CloudNotes
//
//  Created by iluxsm on 2021/03/04.
//

import Foundation

struct ListVCLiteral {
    static let navigationTitle: String = "메모"
}

/// actionSheeet 타입의 더 보기 UIAlertController 관련 문자열
enum MoreActionSheet: String {
    case share = "공유..."
    case delete = "삭제"
    case cancel = "취소"
}

/// alert 타입의 더 보기 - 삭제 UIAlertController 관련 문자열
enum MemoDeleteAlert: String {
    case title = "진짜요?"
    case message = "진짜로 삭제하시겠습니까?"
    case cancelAction = "취소"
    case deleteAction = "삭제"
}

/// 첫 생성된 셀 문자열 기본 값
enum CellDefaultString: String {
    case title = "새로운 메모"
    case body = "추가 텍스트 없음"
}
