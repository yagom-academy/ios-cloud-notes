//
//  UITextView+Extension.swift
//  CloudNotes
//
//  Created by 홍정아 on 2021/09/08.
//

import UIKit

extension UITextView {
    private var texts: [String]? {
        return self.text.components(separatedBy: String.lineBreak)
    }
    
    private var titleStartIndex: Int {
        if let texts = texts,
           let firstNonEmptyIndex = texts.firstIndex(where: { $0.isEmpty == false })
        {
            let firstNonEmptyIndexToInt = texts.distance(from: texts.startIndex,
                                                         to: firstNonEmptyIndex)
            return firstNonEmptyIndexToInt
        }
        return .zero
    }
    
    private var bodyStartIndex: Int? {
        if let textLength = texts?.count,
           textLength > titleStartIndex + 1
        {
            let bodyStartIndex = titleStartIndex + 1
            return texts?[bodyStartIndex].isEmpty == false ? bodyStartIndex : bodyStartIndex + 1
        }
        return nil
    }
    
    var title: String? {
        return texts?[titleStartIndex]
    }
    
    var body: String? {
        guard let bodyStartIndex = bodyStartIndex else { return nil }
        
        return texts?[bodyStartIndex...].joined(separator: String.lineBreak)
    }
}
