//
//  Memo.swift
//  CloudNotes
//
//  Created by YongHoon JJo on 2021/09/02.
//

import Foundation

struct Memo {
    static private let maximumPreviewCount = 50
    
    var title: String
    var body: String
    private var lastModified: TimeInterval
    var previewBody: String {
        return generatePreviewText(from: body)
    }
    var formatedLastModified: String? {
        let date = Date(timeIntervalSince1970: lastModified)
        return date.transformFormattedType()
    }
    
    init(title: String, body: String, lastModified: TimeInterval) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
    }
    
    private func generatePreviewText(from text: String) -> String {
        guard text.count > Memo.maximumPreviewCount else { return text }
        
        let previewEndIndex = text.index(text.startIndex,
                                       offsetBy: Memo.maximumPreviewCount)
        return text[text.startIndex...previewEndIndex].description
    }
}
