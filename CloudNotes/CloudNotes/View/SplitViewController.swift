//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    
    var primaryViewController: PrimaryViewController?
    var secondaryViewController: SecondaryViewController?
    
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        primaryViewController = PrimaryViewController(showDetailAction: { seleted in            
            self.showSelectedDetail(changed: seleted)
        })
        secondaryViewController = SecondaryViewController()
        
        setViewController(primaryViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
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
        return .primary
    }
}

extension SplitViewController {
    func showSelectedDetail(changed: Memo) {
        let body = changed.body
        secondaryViewController?.updateDetailView(by: body)
        show(.secondary)
    }
}
