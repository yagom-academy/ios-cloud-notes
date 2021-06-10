//
//  ArrayExtension.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/10.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
