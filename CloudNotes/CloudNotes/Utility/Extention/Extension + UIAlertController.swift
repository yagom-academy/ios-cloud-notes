//
//  Extension + UIAlertController.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/12.
//

import UIKit

extension UIAlertController {
    enum NameSpace {
        static let delete = "Delete"
        static let share = "Share..."
        static let cancel = "Cancel"
    }
    static func generateSeeMoreAlertController(deleteHandler: @escaping (UIAlertAction) -> Void,
                                               shareHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NameSpace.delete, style: .destructive, handler: { alert in
            deleteHandler(alert)
        }))
        alert.addAction(UIAlertAction(title: NameSpace.share, style: .default, handler: { alert in
            shareHandler(alert)
        }))
        alert.addAction(UIAlertAction(title: NameSpace.cancel, style: .cancel, handler: nil))
        
        return alert
    }
}
