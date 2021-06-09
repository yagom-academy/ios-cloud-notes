//
//  SendDataProtocol.swift
//  CloudNotes
//
//  Created by sookim on 2021/06/03.
//

import Foundation

protocol SendDataDelegate {

    func sendData(data: Memo, index: Int)
    func isRegularTextViewColor(regular: Bool)
    
}
