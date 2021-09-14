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
    
    enum Cell: String, CustomStringConvertible {
        case newTitle
        case newSummary
        
        var description: String {
            switch self {
            case .newTitle:
                return "새로운 메모"
            case .newSummary:
                return "추가 텍스트 없음"
            }
        }
    }
    
    enum Asset: CustomStringConvertible {
        case yagom
        case diet
        
        var description: String {
            switch self {
            case .yagom:
                return "sample"
            case .diet:
                return "dietSample"
            }
        }
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    var className: String {
        return type(of: self).className
    }
}
