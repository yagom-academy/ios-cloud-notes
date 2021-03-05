//
//  LiteralManager.swift
//  CloudNotes
//
//  Created by iluxsm on 2021/03/04.
//

import Foundation

extension String {
    static let empty = ""

    enum EscapeSequence {
        static let newLine = "\n"
    }
}

/// actionSheeet 타입의 더 보기 UIAlertController 관련 문자열
enum AlertController {
    enum MoreActionSheet {
        static let share = "공유..."
        static let delete = "삭제"
        static let cancel = "취소"
    }

    /// alert 타입의 더 보기 - 삭제 UIAlertController 관련 문자열
    enum MemoDeleteAlert {
        static let title = "진짜요?"
        static let message = "진짜로 삭제하시겠습니까?"
        static let cancelAction = "취소"
        static let deleteAction = "삭제"
    }
}

/// 첫 생성된 셀 문자열 기본 값
enum CellDefaultString {
    static let title = "새로운 메모"
    static let body = "추가 텍스트 없음"
}
