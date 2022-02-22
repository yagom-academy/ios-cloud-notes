//
//  String+splitedText.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/22.
//

import Foundation

extension String {
    var splitedText: (title: String, body: String) {
        let splitedText = self.split(separator: .lineBreak, maxSplits: 1).map { String($0) }
        
        if splitedText.count == 1 {
            return (splitedText[0], .blank)
        } else if splitedText.count == 2 {
            return (splitedText[0], splitedText[1])
        } else {
            return (.blank, .blank)
        }
    }
}
