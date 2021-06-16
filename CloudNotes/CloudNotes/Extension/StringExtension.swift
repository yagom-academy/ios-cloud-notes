//
//  StringExtension.swift
//  CloudNotes
//
//  Created by 기원우 on 2021/06/15.
//

import Foundation

extension String {
    func subString(target: Self, point: String) -> [String] {
        var result: [String] = []
        if let targetPoint = target.range(of: point) {
            let pointDistance = target.distance(from: target.startIndex,
                                                to: targetPoint.lowerBound)
            let pointIndex = String.Index(encodedOffset: pointDistance + 1)
            let title = target[target.startIndex...targetPoint.lowerBound] == "\n" ? "" : target[target.startIndex...targetPoint.lowerBound]
            let body = target[pointIndex..<target.endIndex] == "\n" ? "" :
                target[pointIndex..<target.endIndex]
            
            result.append(String(title))
            result.append(String(body))
        }
        
        return result
    }
    
}
