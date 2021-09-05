//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredPrimaryColumnWidthFraction = 1/3
        
        preferredDisplayMode = UISplitViewController.DisplayMode.allVisible
        
        let detailVC = SecondaryViewController()
        let primaryVC = PrimaryViewController()
        setViewController(primaryVC, for: .primary)
        setViewController(detailVC, for: .secondary)
        self.delegate = self
    }
    
    func splitViewController(_: UISplitViewController, collapseSecondary: UIViewController, onto: UIViewController) -> Bool {
        guard let naviVC = self.viewController(for: .secondary) as? UINavigationController, let detailVC = naviVC.topViewController as? SecondaryViewController else { return false }
        
        return detailVC.navigationItem == nil
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
