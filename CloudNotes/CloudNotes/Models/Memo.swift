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
    var body: String {
        willSet (newVal) {
            previewBody = generatePreviewText(from: newVal)
        }
    }
    private var lastModified: Double {
        willSet (newVal) {
            formatedLastModified = DateManager.transfromFormatedDate(from: newVal)
        }
    }
    var previewBody: String = ""
    var formatedLastModified: String?
    
    init(title: String, body: String, lastModified: Double) {
        self.title = title
        self.body = body
        self.lastModified = lastModified
        self.previewBody = generatePreviewText(from: body)
        self.formatedLastModified = DateManager.transfromFormatedDate(from: lastModified)
    }
    
    private func generatePreviewText(from text: String) -> String {
        guard text.count > Memo.maximumPreviewCount else { return text }
        
        let previewEndIndex = text.index(text.startIndex,
                                       offsetBy: Memo.maximumPreviewCount)
        return text[text.startIndex...previewEndIndex].description
    }
}
