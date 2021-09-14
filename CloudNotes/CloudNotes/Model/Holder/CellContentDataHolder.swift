//
//  d.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/06.
//

import UIKit

final class CellContentDataHolder {
    let titleLabelText: String?
    let dateLabelText: String
    let bodyLabelText: String?
    
    init(title: String?, date: Int64, body: String?) {
        let modifiedDate = DateFormatter().updateLastModifiedDate(Int(date ?? .zero))
        self.dateLabelText = "\(modifiedDate)"
        self.titleLabelText = title
        self.bodyLabelText = body
    }
}
