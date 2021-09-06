//
//  Savable.swift
//  CloudNotes
//
//  Created by Dasoll Park on 2021/09/03.
//

import Foundation

protocol Savable {
    
    var title: String? { get set }
    var body: String? { get set }
    var lastModified: Int? { get set }
}
