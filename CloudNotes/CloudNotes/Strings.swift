//
//  Strings.swift
//  CloudNotes
//
//  Created by Yongwoo Marco on 2021/09/14.
//

import Foundation

enum Strings: String {
    case appTitle
    
    enum VCTitle: CustomStringConvertible {
        case primary
        
        var description: String {
            switch self {
            case .primary:
                return "메모"
            }
        }
    }
    
    enum Alert: CustomStringConvertible {
        case delete
        case add
        case edit
        case cancel
        case deleteTitle
        case deleteMessage
        
        var description: String {
            switch self {
            case .delete:
                return "삭제"
            case .add:
                return "추가"
            case .edit:
                return "수정"
            case .cancel:
                return "취소"
            case .deleteTitle:
                return "진짜요?"
            case .deleteMessage:
                return "정말로 삭제하시겠어요?"
            }
        }
    }
    
    enum ActionSheet: CustomStringConvertible {
        case delete
        case cancel
        case share
        
        var description: String {
            switch self {
            case .delete:
                return "Delete"
            case .cancel:
                return "Cancel"
            case .share:
                return "Share..."
            }
        }
    }
    
    enum KeyboardInput: String {
      case twiceLineBreaks = "\n\n"
    }
}
