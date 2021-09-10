//
//  TextSeparatable.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/10.
//

import Foundation

protocol TextSeparatable {
    
}

extension TextSeparatable {
    func separateText(_ text: String) -> (title: String?, body: String?) {
        let texts = text.components(separatedBy: .newlines)
        let title = texts.first
        let body = texts.filter {
            texts[0].contains($0) == false ? true : false
        }.joined()
        return (title, body)
    }
}
