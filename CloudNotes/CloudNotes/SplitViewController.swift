//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpSplitView()
        initChildViewControllers()
    }
    
    func initChildViewControllers() {
        let primaryViewController = PrimaryChildViewController()
        let secondaryViewController = SecondaryChildViewController()
        let primaryChild = UINavigationController(rootViewController: primaryViewController)
        let secondaryChild = UINavigationController(rootViewController: secondaryViewController)
        
        setViewController(primaryChild, for: .primary)
        setViewController(secondaryChild, for: .secondary)
    }
    
    func setUpSplitView() {
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
    }
}
