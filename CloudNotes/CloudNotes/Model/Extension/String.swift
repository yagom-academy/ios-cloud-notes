//
//  String.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/14.
//

import Foundation

extension String {
    func seperateTitleAndBody() -> (title: String?, body: String) {
        let lineBreaker = "\n"
        let bodyStartIndex = 1
        let seperateArrray = self.components(separatedBy: lineBreaker)
        let title = seperateArrray.first
        let bodyArray = seperateArrray[bodyStartIndex...]
        let body = bodyArray.reduce("") { $0 + lineBreaker + $1 }
        
        return (title, body)
    }
}
