//
//  Extension + UIAlertAction.swift
//  CloudNotes
//
//  Created by KimJaeYoun on 2021/09/13.
//

import UIKit

extension UIAlertAction {
    enum Kind: CustomStringConvertible {
        case share
        case delete
        case cancel
        
        var description: String {
            switch self {
            case .share:
                return "Share..."
            case .delete:
                return "Delete"
            case .cancel:
                return "Cancel"
            }
        }
    }
    
    static func generateUIAlertAction(kindOf kind: Kind, alertStyle: UIAlertAction.Style, completionHandler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: String(describing: kind), style: alertStyle) {
            completionHandler?($0)
        }
    }
}
