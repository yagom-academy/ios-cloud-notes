//
//  ObservableProtocol.swift
//  CloudNotes
//
//  Created by yun on 2021/09/17.
//

import Foundation

class CustomViewModel<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var customType: T {
        didSet {
            listener?(customType)
        }
    }
    
    init(customType: T) {
        self.customType = customType
    }
}
