//
//  ArrayExtension.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/10.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
