//
//  DataSendable.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/11.
//

import Foundation

protocol MemoSendable {
    func didSelectRow(at memo: Memo)
    func textViewModify(at memo: Memo)
}
