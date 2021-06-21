//
//  NoteLiteral.swift
//  CloudNotes
//
//  Created by 배은서 on 2021/06/17.
//

enum NoteLiteral {
    static let defaultTitle: String = "새로운 메모"
    static let defaultBody: String = "추가 텍스트 없음"
    static let empty: String = ""
    static let titleIndex: Int = 0
    static let bodyIndex: Int = 1
    static let navigationItemTitle = "메모"
    static let deleteTitle: String = "Delete"
    static let shareTitle: String = "Share..."
    static let cancelTitle: String = "Cancel"
    static let deleteMessage: String = "정말로 삭제하시겠어요?"
    static let moreButtonImageName: String = "ellipsis.circle"
    
    enum LineBreak {
        static let String: String = "\n"
        static let Character: Character = "\n"
    }
}
