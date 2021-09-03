//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        setViewController(PrimaryViewController(), for: .primary)
        setViewController(SecondaryViewController(), for: .secondary)
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .secondary
    }
}
