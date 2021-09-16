//
//  DataSendable.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/11.
//

import Foundation

protocol MemoEntitySendable {
    func didSelectRow(at memo: MemoEntity)
    func textViewModify(at memo: MemoEntity)
}
