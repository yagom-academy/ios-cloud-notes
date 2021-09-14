//
//  d.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/06.
//

import UIKit

final class CellContentDataHolder {
    let titleLabelText: String?
    let dateLabelText: String?
    let bodyLabelText: String?
    
    init(title: String?, date: String?, body: String?) {
        self.titleLabelText = title
        self.dateLabelText = date
        self.bodyLabelText = body
    }
}
