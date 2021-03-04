//
//  DarkModeColorManager.swift
//  CloudNotes
//
//  Created by 김지혜 on 2021/03/04.
//

import UIKit

struct DarkModeColorManager {
    static let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .unspecified, .light:
            return .black
        case .dark:
            return .white
        }
    }
}
