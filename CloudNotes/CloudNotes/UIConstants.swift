//
//  UIConstants.swift
//  CloudNotes
//
//  Created by Kyungmin Lee on 2021/02/23.
//

import UIKit

enum UIConstants {
    enum layout {
        // MARK: - NotesTableViewCell
        static let notesCellTitleLabelTopOffset: CGFloat = 5
        static let notesCellTitleLabelLeadingOffset: CGFloat = 5
        static let notesCellTitleLabelTrailingOffset: CGFloat = -5
        
        static let notesCellDateLabelTopOffset: CGFloat = 3
        static let notesCellDateLabelLeadingOffset: CGFloat = 0
        static let notesCellDateLabelBottomOffset: CGFloat = -5
        
        static let notesCellBodyLabelLeadingOffset: CGFloat = 40
        static let notesCellBodyLabelTrailingOffset: CGFloat = -5
        
        // MARK: - NoteSplitViewController
        static let noteSplitViewPreferredPrimaryColumnWidthFraction: CGFloat = 1/3
    }
    
    enum strings {
        static let noteViewControllerNavigationBarTitle: String = "메모"
    }
}
