//
//  AlertMessage.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/22.
//

import Foundation

enum AlertMessage {
    case delete
    case deleteCaution
    case connectSuccess
    case connectFailure
    case disconnect
    
    var title: String {
        switch self {
        case .delete:
            return "진짜요?"
        case .deleteCaution:
            return "삭제할 수 없습니다"
        case .connectSuccess:
            return "Dropbox 연동 성공"
        case .connectFailure:
            return "Dropbox 연동 실패"
        case .disconnect:
            return "Dropbox 로그아웃"
        }
    }
    
    var message: String {
        switch self {
        case .delete:
            return "정말로 삭제하시겠어요?"
        case .deleteCaution:
            return "메모는 최소 한 개 존재해야합니다"
        case .connectSuccess:
            return "앞으로 메모장을 Dropbox와 동기화합니다"
        case .connectFailure:
            return "다시 시도해주세요"
        case .disconnect:
            return "성공적으로 로그아웃되었습니다"
        }
    }
}
